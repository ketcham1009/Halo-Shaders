// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo Reach/Armor + Dissolve Legacy"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "bump" {}
		_Splat("Splat", 2D) = "white" {}
		_Primary("Primary", Color) = (1,0,0,1)
		_Secondary("Secondary", Color) = (0,1,0,1)
		_Emissive("Emissive", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (0,0,0,1)
		_Dissolve("Dissolve", 2D) = "white" {}
		_Dissolveamountalt("Dissolve amount alt", Range( 0 , 1)) = 0
		_DisolveEdge("Disolve Edge", Color) = (1,0.3683609,0,0)
		_DissolveMinThreshold("Dissolve Min Threshold", Range( -10 , 2)) = 0
		_DissolveMaxThreshold("Dissolve Max Threshold", Range( 1 , 10)) = 10
		_GradientPower("Gradient Power", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _Primary;
		uniform sampler2D _Splat;
		uniform float4 _Splat_ST;
		uniform float4 _Secondary;
		uniform float4 _EmissiveColor;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float _Dissolveamountalt;
		uniform sampler2D _Dissolve;
		uniform float4 _Dissolve_ST;
		uniform float4 _DisolveEdge;
		uniform float _DissolveMinThreshold;
		uniform float _DissolveMaxThreshold;
		uniform float _GradientPower;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode126 = tex2D( _Texture, uv_Texture );
			float2 uv_Splat = i.uv_texcoord * _Splat_ST.xy + _Splat_ST.zw;
			float4 tex2DNode107 = tex2D( _Splat, uv_Splat );
			o.Albedo = ( tex2DNode126 * ( ( _Primary * tex2DNode107.r ) + ( _Secondary * tex2DNode107.g ) + ( 1.0 - ( tex2DNode107.r + tex2DNode107.g + tex2DNode107.b ) ) ) ).rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			float temp_output_158_0 = ( 1.0 - _Dissolveamountalt );
			float DisolveAmount162 = temp_output_158_0;
			float2 uv_Dissolve = i.uv_texcoord * _Dissolve_ST.xy + _Dissolve_ST.zw;
			float4 color176 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 lerpResult179 = lerp( color176 , _DisolveEdge , (0.0 + (_Dissolveamountalt - 0.0) * (1.0 - 0.0) / (0.01 - 0.0)));
			float4 ifLocalVar182 = 0;
			if( _Dissolveamountalt <= 0.05 )
				ifLocalVar182 = lerpResult179;
			else
				ifLocalVar182 = ( (-0.6 + (DisolveAmount162 - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _Dissolve, uv_Dissolve ) + _DisolveEdge );
			float clampResult196 = clamp( (0.0 + (temp_output_158_0 - 0.0) * (1.0 - 0.0) / (0.2 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult187 = lerp( ( _EmissiveColor * tex2D( _Emissive, uv_Emissive ) ) , ifLocalVar182 , clampResult196);
			o.Emission = lerpResult187.rgb;
			o.Smoothness = tex2DNode126.a;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float4 transform152 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float lerpResult159 = lerp( 1.0 , -1.0 , ( ase_worldPos.y - transform152.y ));
			float LocalPositionGradient166 = ( lerpResult159 + (-1.0 + (0.0 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float4 Opacity181 = ( ( tex2D( _Dissolve, uv_Dissolve ) + (_DissolveMinThreshold + (DisolveAmount162 - 0.0) * (_DissolveMaxThreshold - _DissolveMinThreshold) / (1.0 - 0.0)) ) + ( LocalPositionGradient166 * _GradientPower ) );
			clip( Opacity181.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
8;2;1906;1006;1545.603;-116.061;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;150;-2400.708,220.6056;Inherit;False;983.0073;494.5271;Create Position;8;166;161;159;157;156;155;153;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;151;-1407.572,217.3922;Inherit;False;1304.632;831.9492;Disintegration Emissive Effect;12;182;179;178;176;175;174;172;171;162;158;138;196;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;152;-2269.1,443.458;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;153;-2253.123,307.6393;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-2040.702,402.6059;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1366.715,702.3817;Inherit;False;Property;_Dissolveamountalt;Dissolve amount alt;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-2350.708,600.1327;Inherit;False;Constant;_VerticalMask;Vertical Mask;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;159;-1876.703,270.6057;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;158;-1078.141,610.5807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;157;-2044.702,501.6058;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;160;-2537.494,736.0737;Inherit;False;1109.507;516.1575;Disintegration Alpha Effect;11;181;180;177;173;170;169;168;167;165;164;163;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-914.5615,603.6567;Inherit;False;DisolveAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;-1845.703,415.606;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-2485.364,1070.157;Inherit;False;Property;_DissolveMinThreshold;Dissolve Min Threshold;11;0;Create;True;0;0;0;False;0;False;0;-0.67;-10;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-2486.531,1139.123;Inherit;False;Property;_DissolveMaxThreshold;Dissolve Max Threshold;12;0;Create;True;0;0;0;False;0;False;10;10;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;197;-1661.459,-567.0957;Inherit;False;1039.288;792.265;Main;11;107;113;116;115;122;120;117;126;124;132;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-2484.069,989.6154;Inherit;False;162;DisolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-1711.703,320.6057;Inherit;False;LocalPositionGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;107;-1611.459,-165.8307;Inherit;True;Property;_Splat;Splat;3;0;Create;True;0;0;0;False;0;False;-1;None;d3dd2d52e2866ee4b8c29515ec82a601;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;169;-2195.1,1021.228;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-2007.325,1089.895;Inherit;False;166;LocalPositionGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;170;-2487.494,794.5457;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;5a16161a342da954894bee9e0157a74b;True;0;False;white;Auto;False;Instance;175;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;-2010.325,1162.895;Inherit;False;Property;_GradientPower;Gradient Power;13;0;Create;True;0;0;0;False;0;False;0;2.22;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-1258.691,-53.54661;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1736.328,1112.186;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-2033.891,798.7987;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;183;-614.565,-224.8449;Inherit;False;496.4278;439.9171;Standard Emissive Block;3;186;185;184;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;175;-796.7489,267.3923;Inherit;True;Property;_Dissolve;Dissolve;8;0;Create;True;0;0;0;False;0;False;-1;None;f69915385685ea14e804f18779cf92cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;172;-1106.716,809.8636;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;171;-684.0703,452.879;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;115;-1547.459,18.1693;Inherit;False;Property;_Secondary;Secondary;5;0;Create;True;0;0;0;False;0;False;0,1,0,1;0.235294,0.1764705,0.6039216,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;174;-890.7148,842.3416;Inherit;False;Property;_DisolveEdge;Disolve Edge;10;0;Create;True;0;0;0;False;0;False;1,0.3683609,0,0;0.4420614,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;176;-893.3308,676.8826;Inherit;False;Constant;_Color0;Color 0;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;116;-1557.459,-323.8307;Inherit;False;Property;_Primary;Primary;4;0;Create;True;0;0;0;False;0;False;1,0,0,1;0.1411764,0.5372549,0.6588235,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;184;-564.5634,-14.92795;Inherit;True;Property;_Emissive;Emissive;6;0;Create;True;0;0;0;False;0;False;-1;None;ce46fb81c0fc47d41a4dcfc4501f5599;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;120;-1116.691,-59.54652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1256.285,-400.2689;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;178;-438.5993,480.8239;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1253.285,-197.2689;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;195;-1355.843,314.658;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-1841.762,799.1067;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;185;-476.4983,-174.8449;Inherit;False;Property;_EmissiveColor;Emissive Color;7;0;Create;True;0;0;0;False;0;False;0,0,0,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;179;-598.5861,636.9747;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;196;-1077.635,350.5022;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-287.1357,-67.20306;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;182;-299.374,542.4257;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0.05;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;126;-1609.459,-508.8309;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;7f94a6cb35c68b84f99ff8894a53ea68;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-1071.983,-323.9955;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-1639.323,794.1608;Inherit;True;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;486.6322,-25.78187;Inherit;False;181;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;187;147.6381,-19.33179;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;133;-942.1702,-233.7038;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;bba14efae3961494191d212b3922d8f7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-926.3829,-517.0957;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;756.2319,-161.4241;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo Reach/Armor + Dissolve Legacy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;155;0;153;2
WireConnection;155;1;152;2
WireConnection;159;2;155;0
WireConnection;158;0;138;0
WireConnection;157;0;156;0
WireConnection;162;0;158;0
WireConnection;161;0;159;0
WireConnection;161;1;157;0
WireConnection;166;0;161;0
WireConnection;169;0;163;0
WireConnection;169;3;165;0
WireConnection;169;4;164;0
WireConnection;113;0;107;1
WireConnection;113;1;107;2
WireConnection;113;2;107;3
WireConnection;177;0;168;0
WireConnection;177;1;167;0
WireConnection;173;0;170;0
WireConnection;173;1;169;0
WireConnection;172;0;138;0
WireConnection;171;0;162;0
WireConnection;120;0;113;0
WireConnection;122;0;116;0
WireConnection;122;1;107;1
WireConnection;178;0;171;0
WireConnection;178;1;175;0
WireConnection;178;2;174;0
WireConnection;117;0;115;0
WireConnection;117;1;107;2
WireConnection;195;0;158;0
WireConnection;180;0;173;0
WireConnection;180;1;177;0
WireConnection;179;0;176;0
WireConnection;179;1;174;0
WireConnection;179;2;172;0
WireConnection;196;0;195;0
WireConnection;186;0;185;0
WireConnection;186;1;184;0
WireConnection;182;0;138;0
WireConnection;182;2;178;0
WireConnection;182;3;179;0
WireConnection;182;4;179;0
WireConnection;124;0;122;0
WireConnection;124;1;117;0
WireConnection;124;2;120;0
WireConnection;181;0;180;0
WireConnection;187;0;186;0
WireConnection;187;1;182;0
WireConnection;187;2;196;0
WireConnection;132;0;126;0
WireConnection;132;1;124;0
WireConnection;0;0;132;0
WireConnection;0;1;133;0
WireConnection;0;2;187;0
WireConnection;0;4;126;4
WireConnection;0;10;189;0
ASEEND*/
//CHKSM=077EF9723712FAEF95463CC2907AE07975A09EFF