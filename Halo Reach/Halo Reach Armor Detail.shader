// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo Reach/Armor + Detail"
{
	Properties
	{
		[Header(Standard Textures)]_Texture("Texture", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "bump" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( 0 , 1)) = 0.75
		[Header(SplatMap and Colors)]_SplatMap("SplatMap", 2D) = "white" {}
		_Primary("Primary", Color) = (1,0,0,1)
		_Secondary("Secondary", Color) = (0,1,0,1)
		[Header(Detail Textures)]_DetailTexture1("Detail Texture", 2D) = "white" {}
		_DetailNormal1("Detail Normal", 2D) = "bump" {}
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
		uniform sampler2D _DetailNormal1;
		uniform float4 _DetailNormal1_ST;
		uniform sampler2D _DetailTexture1;
		uniform float4 _DetailTexture1_ST;
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
			float2 uv_DetailNormal1 = i.uv_texcoord * _DetailNormal1_ST.xy + _DetailNormal1_ST.zw;
			o.Normal = ( ( UnpackNormal( tex2D( _Normal, uv_Normal ) ) / 2.0 ) + ( UnpackNormal( tex2D( _DetailNormal1, uv_DetailNormal1 ) ) / 2.0 ) );
			float2 uv_DetailTexture1 = i.uv_texcoord * _DetailTexture1_ST.xy + _DetailTexture1_ST.zw;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode1 = tex2D( _Texture, uv_Texture );
			float2 uv_SplatMap = i.uv_texcoord * _SplatMap_ST.xy + _SplatMap_ST.zw;
			float4 tex2DNode3 = tex2D( _SplatMap, uv_SplatMap );
			float4 blendOpSrc122 = ( tex2D( _DetailTexture1, uv_DetailTexture1 ) * 2.0 );
			float4 blendOpDest122 = ( tex2DNode1 * ( ( _Primary * tex2DNode3.r ) + ( _Secondary * tex2DNode3.g ) + ( 1.0 - ( tex2DNode3.r + tex2DNode3.g + tex2DNode3.b ) ) ) );
			float4 lerpBlendMode122 = lerp(blendOpDest122,2.0f*blendOpDest122*blendOpSrc122 + blendOpDest122*blendOpDest122*(1.0f - 2.0f*blendOpSrc122),( 1.0 - 0.0 ));
			o.Albedo = lerpBlendMode122.rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = ( _EmissiveColor * tex2D( _Emissive, uv_Emissive ) ).rgb;
			float temp_output_120_0 = ( tex2DNode1.a * _SmoothnessMultiplier );
			float clampResult131 = clamp( temp_output_120_0 , 0.0 , 0.5 );
			o.Metallic = clampResult131;
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
7;6;1895;1012;1365.544;1014.464;1.729667;True;False
Node;AmplifyShaderEditor.CommentaryNode;118;-1408.135,-638.6688;Inherit;False;1048.288;792.2648;RG (halo reach) Splatmap Texture;10;3;7;5;25;13;24;14;1;18;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-1358.135,-237.4041;Inherit;True;Property;_SplatMap;SplatMap;4;1;[Header];Create;True;1;SplatMap and Colors;0;0;False;0;False;-1;None;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1294.135,-53.40411;Inherit;False;Property;_Secondary;Secondary;6;0;Create;True;0;0;0;False;0;False;0,1,0,1;0.2352934,0.1764699,0.6039216,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1007.368,-169.12;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-1304.135,-395.4039;Inherit;False;Property;_Primary;Primary;5;0;Create;True;0;0;0;False;0;False;1,0,0,1;0.1411757,0.5372549,0.6588235,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1016.962,-275.8423;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;24;-867.1686,-199.72;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1002.962,-471.8421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;124;-920.3928,-1578.013;Inherit;True;Property;_DetailTexture1;Detail Texture;7;1;[Header];Create;True;1;Detail Textures;0;0;False;0;False;-1;None;cf49c8bcde20e4a4a945a409d8604415;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;-412.9922,-29.71689;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;3;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;127;-223.3067,-572.0773;Inherit;True;Property;_DetailNormal1;Detail Normal;8;0;Create;True;0;0;0;False;0;False;-1;None;73f484c11b9d196418d456ae8dead358;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1356.135,-580.404;Inherit;True;Property;_Texture;Texture;1;1;[Header];Create;True;1;Standard Textures;0;0;False;0;False;-1;None;46a38646d97677f429dba4c00bbdb7c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-800.6602,-377.5687;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-769.2327,-1377.395;Inherit;False;Constant;_Float1;Float 0;15;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-219.0098,-764.2167;Inherit;True;Property;_Normal;Normal;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;d9413caed884e6b4fbfd146ccfa9430f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;130;64.45985,-617.1158;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;112;-866.3386,164.7674;Inherit;False;496.4278;439.9171;Standard Emissive Block;3;27;28;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-573.5577,-1427.499;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;121;-310.2246,-1272.791;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;129;205.4599,-699.1158;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;27;-816.3375,374.6847;Inherit;True;Property;_Emissive;Emissive;9;1;[Header];Create;True;1;Emissive Settings;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;128;211.5839,-558.4678;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-673.0603,-588.6688;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-115.3921,-80.91685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-728.2725,214.7675;Inherit;False;Property;_EmissiveColor;Emissive Color;10;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;131;161.7521,-209.3038;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-538.9094,322.4097;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;122;-139.5157,-1328.047;Inherit;True;SoftLight;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;337.2159,-644.0619;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;795.2036,-312.9466;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo Reach/Armor + Detail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;3;1
WireConnection;25;1;3;2
WireConnection;25;2;3;3
WireConnection;14;0;7;0
WireConnection;14;1;3;2
WireConnection;24;0;25;0
WireConnection;13;0;5;0
WireConnection;13;1;3;1
WireConnection;18;0;13;0
WireConnection;18;1;14;0
WireConnection;18;2;24;0
WireConnection;123;0;124;0
WireConnection;123;1;125;0
WireConnection;129;0;2;0
WireConnection;129;1;130;0
WireConnection;128;0;127;0
WireConnection;128;1;130;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;120;0;1;4
WireConnection;120;1;119;0
WireConnection;131;0;120;0
WireConnection;20;0;28;0
WireConnection;20;1;27;0
WireConnection;122;0;123;0
WireConnection;122;1;19;0
WireConnection;122;2;121;0
WireConnection;126;0;129;0
WireConnection;126;1;128;0
WireConnection;0;0;122;0
WireConnection;0;1;126;0
WireConnection;0;2;20;0
WireConnection;0;3;131;0
WireConnection;0;4;120;0
ASEEND*/
//CHKSM=6B59F4C2FAD0EF518247B87A98BA97B556E40ED6