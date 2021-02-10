// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo Reach/Armor"
{
	Properties
	{
		[Header(Standard Textures)]_Texture("Texture", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "bump" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( 0 , 1)) = 0.75
		[Header(SplatMap and Colors)]_SplatMap("SplatMap", 2D) = "white" {}
		_Primary("Primary", Color) = (1,0,0,1)
		_Secondary("Secondary", Color) = (0,1,0,1)
		[Header(Emissive Settings)]_Emissive("Emissive", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (0,0,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _Primary;
		uniform sampler2D _SplatMap;
		uniform float4 _SplatMap_ST;
		uniform float4 _Secondary;
		uniform float4 _EmissiveColor;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float _SmoothnessMultiplier;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode1 = tex2D( _Texture, uv_Texture );
			float2 uv_SplatMap = i.uv_texcoord * _SplatMap_ST.xy + _SplatMap_ST.zw;
			float4 tex2DNode3 = tex2D( _SplatMap, uv_SplatMap );
			o.Albedo = ( tex2DNode1 * ( ( _Primary * tex2DNode3.r ) + ( _Secondary * tex2DNode3.g ) + ( 1.0 - ( tex2DNode3.r + tex2DNode3.g + tex2DNode3.b ) ) ) ).rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = ( _EmissiveColor * tex2D( _Emissive, uv_Emissive ) ).rgb;
			float temp_output_120_0 = ( tex2DNode1.a * _SmoothnessMultiplier );
			float clampResult121 = clamp( temp_output_120_0 , 0.0 , 0.5 );
			o.Metallic = clampResult121;
			o.Smoothness = temp_output_120_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
-1903;23;1895;1035;1115.587;746.5534;1.226361;True;True
Node;AmplifyShaderEditor.CommentaryNode;118;-1408.135,-638.6688;Inherit;False;1048.288;792.2648;RG (halo reach) Splatmap Texture;10;3;7;5;25;13;24;14;1;18;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-1358.135,-237.4041;Inherit;True;Property;_SplatMap;SplatMap;4;1;[Header];Create;True;1;SplatMap and Colors;0;0;False;0;False;-1;None;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1294.135,-53.40411;Inherit;False;Property;_Secondary;Secondary;6;0;Create;True;0;0;0;False;0;False;0,1,0,1;0.2352934,0.1764699,0.6039216,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1007.368,-169.12;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-1304.135,-395.4039;Inherit;False;Property;_Primary;Primary;5;0;Create;True;0;0;0;False;0;False;1,0,0,1;0.1411757,0.5372549,0.6588235,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;112;-866.3386,164.7674;Inherit;False;496.4278;439.9171;Standard Emissive Block;3;27;28;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1002.962,-471.8421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1356.135,-580.404;Inherit;True;Property;_Texture;Texture;1;1;[Header];Create;True;1;Standard Textures;0;0;False;0;False;-1;None;46a38646d97677f429dba4c00bbdb7c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1016.962,-275.8423;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;24;-867.1686,-199.72;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-373.8459,-89.96861;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;3;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-816.3375,374.6847;Inherit;True;Property;_Emissive;Emissive;7;1;[Header];Create;True;1;Emissive Settings;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-728.2725,214.7675;Inherit;False;Property;_EmissiveColor;Emissive Color;8;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-800.6602,-377.5687;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-107.2459,-157.1686;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-673.0603,-588.6688;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-538.9094,322.4097;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-264.6587,-799.5394;Inherit;True;Property;_Normal;Normal;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;d9413caed884e6b4fbfd146ccfa9430f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;121;35.39024,-241.3634;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;425.2036,-244.9466;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo Reach/Armor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;3;1
WireConnection;25;1;3;2
WireConnection;25;2;3;3
WireConnection;13;0;5;0
WireConnection;13;1;3;1
WireConnection;14;0;7;0
WireConnection;14;1;3;2
WireConnection;24;0;25;0
WireConnection;18;0;13;0
WireConnection;18;1;14;0
WireConnection;18;2;24;0
WireConnection;120;0;1;4
WireConnection;120;1;119;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;20;0;28;0
WireConnection;20;1;27;0
WireConnection;121;0;120;0
WireConnection;0;0;19;0
WireConnection;0;1;2;0
WireConnection;0;2;20;0
WireConnection;0;3;121;0
WireConnection;0;4;120;0
ASEEND*/
//CHKSM=1D3E14DCA522794078D55CD3680D4B13328FDD17