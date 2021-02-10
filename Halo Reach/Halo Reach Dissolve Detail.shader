// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo Reach/Armor + Dissolve + Detail"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Standard Textures)]_Texture("Texture", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( 0 , 1)) = 0.75
		[Header(Detail Textures)]_DetailTexture("Detail Texture", 2D) = "white" {}
		_DetailNormal("Detail Normal", 2D) = "bump" {}
		[Header(SplatMap and Colors)]_Splat("Splat", 2D) = "white" {}
		_Primary("Primary", Color) = (1,0.1732519,0.0990566,1)
		_Secondary("Secondary", Color) = (0.1307173,1,0,1)
		[Header(Emissive Settings)]_Emissive("Emissive", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (0,0,0,1)
		[Header(Dissolve Settings)]_Dissolve("Dissolve", 2D) = "white" {}
		_Dissolveamount("Dissolve amount", Range( 0 , 1)) = 0
		_DisolveColor("Disolve Color", Color) = (1,0.3683609,0,0)
		_DissolveMinThreshold("Dissolve Min Threshold", Range( -10 , 2)) = 0
		_DissolveMaxThreshold("Dissolve Max Threshold", Range( 1 , 20)) = 10
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
		uniform sampler2D _DetailNormal;
		uniform float4 _DetailNormal_ST;
		uniform sampler2D _DetailTexture;
		uniform float4 _DetailTexture_ST;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _Primary;
		uniform sampler2D _Splat;
		uniform float4 _Splat_ST;
		uniform float4 _Secondary;
		uniform float4 _EmissiveColor;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float4 _DisolveColor;
		uniform sampler2D _Dissolve;
		uniform float4 _Dissolve_ST;
		uniform float _Dissolveamount;
		uniform float _DissolveMinThreshold;
		uniform float _DissolveMaxThreshold;
		uniform float _GradientPower;
		uniform float _SmoothnessMultiplier;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 uv_DetailNormal = i.uv_texcoord * _DetailNormal_ST.xy + _DetailNormal_ST.zw;
			o.Normal = ( ( UnpackNormal( tex2D( _Normal, uv_Normal ) ) / 2.0 ) + ( UnpackNormal( tex2D( _DetailNormal, uv_DetailNormal ) ) / 2.0 ) );
			float2 uv_DetailTexture = i.uv_texcoord * _DetailTexture_ST.xy + _DetailTexture_ST.zw;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode1 = tex2D( _Texture, uv_Texture );
			float2 uv_Splat = i.uv_texcoord * _Splat_ST.xy + _Splat_ST.zw;
			float4 tex2DNode3 = tex2D( _Splat, uv_Splat );
			float4 blendOpSrc170 = ( tex2D( _DetailTexture, uv_DetailTexture ) * 2.0 );
			float4 blendOpDest170 = ( tex2DNode1 * ( ( _Primary * tex2DNode3.r ) + ( _Secondary * tex2DNode3.g ) + ( 1.0 - ( tex2DNode3.r + tex2DNode3.g + tex2DNode3.b ) ) ) );
			float4 lerpBlendMode170 = lerp(blendOpDest170,2.0f*blendOpDest170*blendOpSrc170 + blendOpDest170*blendOpDest170*(1.0f - 2.0f*blendOpSrc170),( 1.0 - tex2DNode1.a ));
			o.Albedo = lerpBlendMode170.rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			float2 uv_Dissolve = i.uv_texcoord * _Dissolve_ST.xy + _Dissolve_ST.zw;
			float DisolveAmount106 = ( 1.0 - _Dissolveamount );
			float3 ase_worldPos = i.worldPos;
			float4 transform85 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float lerpResult94 = lerp( 1.0 , -1.0 , ( ase_worldPos.y - transform85.y ));
			float LocalPositionGradient96 = ( lerpResult94 + (-1.0 + (0.0 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float4 Opacity108 = ( ( tex2D( _Dissolve, uv_Dissolve ) + (_DissolveMinThreshold + (DisolveAmount106 - 0.0) * (_DissolveMaxThreshold - _DissolveMinThreshold) / (1.0 - 0.0)) ) + ( LocalPositionGradient96 * _GradientPower ) );
			float4 temp_cast_1 = 1;
			float4 temp_cast_2 = 3;
			float4 clampResult136 = clamp( ( 1.0 - ( Opacity108 - temp_cast_1 ) ) , float4( 0,0,0,0 ) , temp_cast_2 );
			o.Emission = ( ( _EmissiveColor * tex2D( _Emissive, uv_Emissive ) ) + ( _DisolveColor * clampResult136 * 3 ) ).rgb;
			float temp_output_167_0 = ( tex2DNode1.a * _SmoothnessMultiplier );
			float clampResult180 = clamp( temp_output_167_0 , 0.0 , 0.5 );
			o.Metallic = clampResult180;
			o.Smoothness = temp_output_167_0;
			o.Alpha = 1;
			clip( Opacity108.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
7;6;1895;1012;2747.132;771.1666;2.305682;True;False
Node;AmplifyShaderEditor.CommentaryNode;97;-2870.392,459.1534;Inherit;False;983.0073;494.5271;Create Position;8;85;84;86;93;92;94;95;96;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;84;-2722.806,546.1871;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;85;-2738.784,682.0064;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;114;-1670.354,810.44;Inherit;False;1057.632;647.9492;Disintegration Emissive Effect;11;38;134;135;132;136;139;140;141;33;106;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2820.392,838.6805;Inherit;False;Constant;_VerticalMask;Vertical Mask;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1644.454,886.042;Inherit;False;Property;_Dissolveamount;Dissolve amount;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-2510.385,641.1537;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1364.522,886.2285;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;93;-2514.385,740.1537;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;-2346.385,509.1534;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1200.044,878.7043;Inherit;False;DisolveAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;115;-2865.976,978.2213;Inherit;False;1109.507;516.1575;Disintegration Alpha Effect;11;108;103;102;100;101;99;104;98;90;107;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2315.385,654.1537;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-2181.385,559.1536;Inherit;False;LocalPositionGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2812.551,1231.763;Inherit;False;106;DisolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2815.014,1381.271;Inherit;False;Property;_DissolveMaxThreshold;Dissolve Max Threshold;15;0;Create;True;0;0;0;False;0;False;10;10;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2813.846,1312.305;Inherit;False;Property;_DissolveMinThreshold;Dissolve Min Threshold;14;0;Create;True;0;0;0;False;0;False;0;0;-10;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2338.807,1405.043;Inherit;False;Property;_GradientPower;Gradient Power;16;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-2815.976,1036.693;Inherit;True;Property;_Dissolve;Dissolve;11;1;[Header];Create;True;1;Dissolve Settings;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;101;-2335.807,1332.043;Inherit;False;96;LocalPositionGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;98;-2523.582,1263.376;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2007.88,1356.809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-2362.373,1040.946;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-2170.244,1041.254;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;118;-1298.135,-700.6688;Inherit;False;1048.288;792.2648;RG (halo reach) Splatmap Texture;14;3;7;5;25;13;24;14;1;18;19;158;175;171;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1967.804,1036.308;Inherit;True;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-1660.857,1197.644;Inherit;False;108;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1238.135,-291.4041;Inherit;True;Property;_Splat;Splat;6;1;[Header];Create;True;1;SplatMap and Colors;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;141;-1594.157,1283.944;Inherit;False;Constant;_Int1;Int 1;14;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;5;-1157.135,-451.4039;Inherit;False;Property;_Primary;Primary;7;0;Create;True;0;0;0;False;0;False;1,0.1732519,0.0990566,1;0,0.2039211,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;139;-1447.157,1214.944;Inherit;False;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-1156.135,-107.4041;Inherit;False;Property;_Secondary;Secondary;8;0;Create;True;0;0;0;False;0;False;0.1307173,1,0,1;0,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-868.368,-264.12;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;135;-1304.818,1207.468;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;132;-1263.754,1320.813;Inherit;False;Constant;_Int0;Int 0;14;0;Create;True;0;0;0;False;0;False;3;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1914.76,-12.18103;Inherit;False;496.4278;439.9171;Standard Emissive Block;3;27;28;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;24;-750.1686,-266.72;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-872.9623,-349.8423;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-863.962,-451.8421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;19.7639,-1276.672;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-1776.694,37.81897;Inherit;False;Property;_EmissiveColor;Emissive Color;10;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;306.7702,-1129.704;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-630.2032,-1.10191;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;158;-917.6392,-84.56198;Inherit;True;Property;_DetailTexture;Detail Texture;4;1;[Header];Create;True;1;Detail Textures;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;-203.312,-288.5153;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;3;0;Create;True;0;0;0;False;0;False;0.75;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;136;-1109.956,1213.244;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;27;-1864.759,197.7362;Inherit;True;Property;_Emissive;Emissive;9;1;[Header];Create;True;1;Emissive Settings;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-729.3376,-398.1099;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;38;-1269.997,1008.79;Inherit;False;Property;_DisolveColor;Disolve Color;13;0;Create;True;0;0;0;False;0;False;1,0.3683609,0,0;1,0.3683608,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1236.135,-635.404;Inherit;True;Property;_Texture;Texture;1;1;[Header];Create;True;1;Standard Textures;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;150;15.2085,-1086.99;Inherit;True;Property;_DetailNormal;Detail Normal;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;178;453.8943,-1071.056;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-684.4595,-646.1502;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-839.46,1185.041;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;177;447.7703,-1211.704;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1587.331,145.4612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-487.7241,-124.4985;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;82.41983,-360.1745;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;171;-621.0489,-438.4378;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;170;-489.7337,-365.7156;Inherit;True;SoftLight;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;180;194.0533,-203.4515;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-368.7124,534.5848;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;579.5261,-1156.65;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-212.4062,200.757;Inherit;False;108;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;562.2036,-74.94659;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo Reach/Armor + Dissolve + Detail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;84;2
WireConnection;92;1;85;2
WireConnection;53;0;33;0
WireConnection;93;0;86;0
WireConnection;94;2;92;0
WireConnection;106;0;53;0
WireConnection;95;0;94;0
WireConnection;95;1;93;0
WireConnection;96;0;95;0
WireConnection;98;0;107;0
WireConnection;98;3;90;0
WireConnection;98;4;91;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;99;0;104;0
WireConnection;99;1;98;0
WireConnection;103;0;99;0
WireConnection;103;1;102;0
WireConnection;108;0;103;0
WireConnection;139;0;140;0
WireConnection;139;1;141;0
WireConnection;25;0;3;1
WireConnection;25;1;3;2
WireConnection;25;2;3;3
WireConnection;135;0;139;0
WireConnection;24;0;25;0
WireConnection;14;0;7;0
WireConnection;14;1;3;2
WireConnection;13;0;5;0
WireConnection;13;1;3;1
WireConnection;136;0;135;0
WireConnection;136;2;132;0
WireConnection;18;0;13;0
WireConnection;18;1;14;0
WireConnection;18;2;24;0
WireConnection;178;0;150;0
WireConnection;178;1;176;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;134;0;38;0
WireConnection;134;1;136;0
WireConnection;134;2;132;0
WireConnection;177;0;2;0
WireConnection;177;1;176;0
WireConnection;20;0;28;0
WireConnection;20;1;27;0
WireConnection;175;0;158;0
WireConnection;175;1;152;0
WireConnection;167;0;1;4
WireConnection;167;1;166;0
WireConnection;171;0;1;4
WireConnection;170;0;175;0
WireConnection;170;1;19;0
WireConnection;170;2;171;0
WireConnection;180;0;167;0
WireConnection;146;0;20;0
WireConnection;146;1;134;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;0;0;170;0
WireConnection;0;1;179;0
WireConnection;0;2;146;0
WireConnection;0;3;180;0
WireConnection;0;4;167;0
WireConnection;0;10;109;0
ASEEND*/
//CHKSM=2CAF3599D72B531FEEECAFA66534775611C7DF23