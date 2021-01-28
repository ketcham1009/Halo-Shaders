// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo Reach/Visor + Disolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Visor Colors)]_FresnelPower("Fresnel Power", Float) = 0.5
		_FresnelBias("Fresnel Bias", Float) = 0
		_Color1("Color 1", Color) = (0,0.1342866,1,0)
		_Color2("Color 2", Color) = (1,0,0,0)
		[Header(Textures)]_Texture("Texture", 2D) = "white" {}
		[Normal]_Normal("Normal", 2D) = "bump" {}
		[Normal]_VisorOverlayNormal("Visor Overlay Normal", 2D) = "bump" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[Header(Dissolve FX)]_DissolveMask("Dissolve Mask", 2D) = "white" {}
		_Dissolveamount("Dissolve amount", Range( 0 , 1)) = 0
		_DissolveColor("Dissolve Color", Color) = (1,0.3683609,0,0)
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
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _VisorOverlayNormal;
		uniform float4 _VisorOverlayNormal_ST;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _FresnelBias;
		uniform float _FresnelPower;
		uniform float4 _DissolveColor;
		uniform sampler2D _DissolveMask;
		uniform float4 _DissolveMask_ST;
		uniform float _Dissolveamount;
		uniform float _DissolveMinThreshold;
		uniform float _DissolveMaxThreshold;
		uniform float _GradientPower;
		uniform float _Metallic;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _SmoothnessMultiplier;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_VisorOverlayNormal = i.uv_texcoord * _VisorOverlayNormal_ST.xy + _VisorOverlayNormal_ST.zw;
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = ( UnpackNormal( tex2D( _VisorOverlayNormal, uv_VisorOverlayNormal ) ) + UnpackNormal( tex2D( _Normal, uv_Normal ) ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2 = ( _FresnelBias + 1.0 * pow( 1.0 - fresnelNdotV2, _FresnelPower ) );
			float4 lerpResult3 = lerp( _Color1 , _Color2 , fresnelNode2);
			o.Albedo = lerpResult3.rgb;
			float2 uv_DissolveMask = i.uv_texcoord * _DissolveMask_ST.xy + _DissolveMask_ST.zw;
			float DisolveAmount150 = ( 1.0 - _Dissolveamount );
			float4 transform115 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float lerpResult121 = lerp( 1.0 , -1.0 , ( ase_worldPos.y - transform115.y ));
			float LocalPositionGradient125 = ( lerpResult121 + (-1.0 + (0.0 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float4 Opacity143 = ( ( tex2D( _DissolveMask, uv_DissolveMask ) + (_DissolveMinThreshold + (DisolveAmount150 - 0.0) * (_DissolveMaxThreshold - _DissolveMinThreshold) / (1.0 - 0.0)) ) + ( LocalPositionGradient125 * _GradientPower ) );
			float4 temp_cast_1 = 1;
			float4 temp_cast_2 = 3;
			float4 clampResult157 = clamp( ( 1.0 - ( Opacity143 - temp_cast_1 ) ) , float4( 0,0,0,0 ) , temp_cast_2 );
			o.Emission = ( _DissolveColor * clampResult157 * 3 ).rgb;
			o.Metallic = _Metallic;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			o.Smoothness = ( tex2D( _Texture, uv_Texture ).a * _SmoothnessMultiplier );
			o.Alpha = 1;
			clip( Opacity143.r - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;6;1906;1012;1855.442;1438.723;2.086889;True;False
Node;AmplifyShaderEditor.CommentaryNode;112;-1399.123,-54.28864;Inherit;False;983.0073;494.5271;Create Position;8;125;122;121;120;117;116;115;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;115;-1267.515,168.5636;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;113;-1251.537,32.74474;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;147;-316.7236,14.2999;Inherit;False;1057.632;647.9492;Disintegration Emissive Effect;11;158;157;156;155;154;153;152;151;150;149;148;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-1349.123,325.2379;Inherit;False;Constant;_VerticalMask;Vertical Mask;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;116;-1039.116,127.7113;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-290.8235,90.30166;Inherit;False;Property;_Dissolveamount;Dissolve amount;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;149;1.10839,98.08837;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;120;-1043.116,226.7109;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-875.1161,-4.288641;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-1535.908,461.1789;Inherit;False;1109.507;516.1575;Disintegration Alpha Effect;11;143;142;138;136;132;131;130;129;128;127;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-844.116,140.7112;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;202.5864,90.2608;Inherit;False;DisolveAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1482.483,714.7209;Inherit;False;150;DisolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-710.1161,45.71135;Inherit;False;LocalPositionGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1483.778,795.2629;Inherit;False;Property;_DissolveMinThreshold;Dissolve Min Threshold;13;0;Create;True;0;0;0;False;0;False;0;-0.67;-10;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1484.946,864.229;Inherit;False;Property;_DissolveMaxThreshold;Dissolve Max Threshold;14;0;Create;True;0;0;0;False;0;False;10;12;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;132;-1485.908,519.6509;Inherit;True;Property;_DissolveMask;Dissolve Mask;10;1;[Header];Create;True;1;Dissolve FX;0;0;False;0;False;-1;None;567f866060385a34c98b9c4663127719;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;130;-1005.739,815.001;Inherit;False;125;LocalPositionGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;131;-1193.514,746.334;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1008.739,888.001;Inherit;False;Property;_GradientPower;Gradient Power;15;0;Create;True;0;0;0;False;0;False;0;1.8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-1032.305,523.9039;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-734.7411,837.2919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-840.1759,524.2119;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-637.736,519.2659;Inherit;True;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-307.2266,401.504;Inherit;False;143;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;151;-240.5266,487.8038;Inherit;False;Constant;_Int0;Int 0;14;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-373.1906,-911.7896;Inherit;False;988.536;836.1795;Iridescent + Texture;8;2;7;8;3;5;4;23;14;;0.246974,0.4716981,0.2727045,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;-93.5266,418.8038;Inherit;False;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-353.1906,-382.6532;Inherit;True;Property;_Texture;Texture;5;1;[Header];Create;True;1;Textures;0;0;False;0;False;None;b8c4e4cc08bb35040acfb8e2409fc6c4;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;8;-246.5717,-523.7751;Inherit;False;Property;_FresnelBias;Fresnel Bias;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-255.3256,-455.4673;Inherit;False;Property;_FresnelPower;Fresnel Power;1;1;[Header];Create;True;1;Visor Colors;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;155;89.87638,524.673;Inherit;False;Constant;_Int1;Int 1;14;0;Create;True;0;0;0;False;0;False;3;0;False;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;154;48.8124,411.328;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;156;83.63347,212.6498;Inherit;False;Property;_DissolveColor;Dissolve Color;12;0;Create;True;0;0;0;False;0;False;1,0.3683609,0,0;0,1,0.3896897,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;84;648.0633,-748.6075;Inherit;True;Property;_Normal;Normal;6;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;050bd426c6315a3489d888715212fcf7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;172;654.1821,-939.0878;Inherit;True;Property;_VisorOverlayNormal;Visor Overlay Normal;7;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;2;-65.27547,-542.4011;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-45.89363,-701.9894;Inherit;False;Property;_Color2;Color 2;4;0;Create;True;0;0;0;False;0;False;1,0,0,0;0.2352936,0.1764701,0.6039216,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;157;243.6743,417.1039;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-48.09456,-861.7896;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0,0.1342866,1,0;0.141176,0.5372549,0.6588235,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;171;661.7353,-215.9583;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;8;0;Create;True;0;0;0;False;0;False;0;0.816;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-62.68647,-380.6453;Inherit;True;Global;Texture;Texture;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;3;181.0999,-673.7157;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;514.1704,388.901;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;939.8394,-13.53776;Inherit;False;143;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;1046.301,-816.1128;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;973.7351,-286.1581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;669.1677,-129.0462;Inherit;False;Property;_Metallic;Metallic;9;0;Create;True;0;0;0;False;0;False;0;0.578;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1169.971,-246.683;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo Reach/Visor + Disolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;116;0;113;2
WireConnection;116;1;115;2
WireConnection;149;0;148;0
WireConnection;120;0;117;0
WireConnection;121;2;116;0
WireConnection;122;0;121;0
WireConnection;122;1;120;0
WireConnection;150;0;149;0
WireConnection;125;0;122;0
WireConnection;131;0;127;0
WireConnection;131;3;128;0
WireConnection;131;4;126;0
WireConnection;136;0;132;0
WireConnection;136;1;131;0
WireConnection;138;0;130;0
WireConnection;138;1;129;0
WireConnection;142;0;136;0
WireConnection;142;1;138;0
WireConnection;143;0;142;0
WireConnection;153;0;152;0
WireConnection;153;1;151;0
WireConnection;154;0;153;0
WireConnection;2;1;8;0
WireConnection;2;3;7;0
WireConnection;157;0;154;0
WireConnection;157;2;155;0
WireConnection;14;0;23;0
WireConnection;3;0;4;0
WireConnection;3;1;5;0
WireConnection;3;2;2;0
WireConnection;158;0;156;0
WireConnection;158;1;157;0
WireConnection;158;2;155;0
WireConnection;173;0;172;0
WireConnection;173;1;84;0
WireConnection;170;0;14;4
WireConnection;170;1;171;0
WireConnection;0;0;3;0
WireConnection;0;1;173;0
WireConnection;0;2;158;0
WireConnection;0;3;169;0
WireConnection;0;4;170;0
WireConnection;0;10;145;0
ASEEND*/
//CHKSM=965DEF5073DCD73D8EB42B2F46E285E031DCF08C