// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ketcham1009/Halo 3/Terrain"
{
	Properties
	{
		[Header(SplatMap)]_SplatMap("SplatMap", 2D) = "white" {}
		[Header(Red Channel)]_RedTexture("Red Texture", 2D) = "white" {}
		[Normal]_RedNormal("Red Normal", 2D) = "bump" {}
		_RedColor("Red Color", Color) = (0,0,0,1)
		[Header(Green Channel)]_GreeenTexture("Greeen Texture", 2D) = "white" {}
		[Normal]_GreenNormal("Green Normal", 2D) = "bump" {}
		_GreenColor("Green Color", Color) = (0,0,0,1)
		[Header(Blue Channel)]_BlueTexture("Blue Texture", 2D) = "white" {}
		[Normal]_BlueNormal("Blue Normal", 2D) = "bump" {}
		_BlueColor("Blue Color", Color) = (0,0,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RedNormal;
		uniform float4 _RedNormal_ST;
		uniform sampler2D _SplatMap;
		uniform float4 _SplatMap_ST;
		uniform sampler2D _GreenNormal;
		uniform float4 _GreenNormal_ST;
		uniform sampler2D _BlueNormal;
		uniform float4 _BlueNormal_ST;
		uniform float4 _RedColor;
		uniform sampler2D _RedTexture;
		uniform float4 _RedTexture_ST;
		uniform float4 _GreenColor;
		uniform sampler2D _GreeenTexture;
		uniform float4 _GreeenTexture_ST;
		uniform float4 _BlueColor;
		uniform sampler2D _BlueTexture;
		uniform float4 _BlueTexture_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RedNormal = i.uv_texcoord * _RedNormal_ST.xy + _RedNormal_ST.zw;
			float2 uv_SplatMap = i.uv_texcoord * _SplatMap_ST.xy + _SplatMap_ST.zw;
			float4 tex2DNode3 = tex2D( _SplatMap, uv_SplatMap );
			float2 uv_GreenNormal = i.uv_texcoord * _GreenNormal_ST.xy + _GreenNormal_ST.zw;
			float2 uv_BlueNormal = i.uv_texcoord * _BlueNormal_ST.xy + _BlueNormal_ST.zw;
			o.Normal = ( ( UnpackNormal( tex2D( _RedNormal, uv_RedNormal ) ) * tex2DNode3.r ) + ( tex2DNode3.g * UnpackNormal( tex2D( _GreenNormal, uv_GreenNormal ) ) ) + ( UnpackNormal( tex2D( _BlueNormal, uv_BlueNormal ) ) * tex2DNode3.b ) );
			float2 uv_RedTexture = i.uv_texcoord * _RedTexture_ST.xy + _RedTexture_ST.zw;
			float2 uv_GreeenTexture = i.uv_texcoord * _GreeenTexture_ST.xy + _GreeenTexture_ST.zw;
			float2 uv_BlueTexture = i.uv_texcoord * _BlueTexture_ST.xy + _BlueTexture_ST.zw;
			o.Albedo = ( ( ( _RedColor * tex2DNode3.r ) + ( tex2D( _RedTexture, uv_RedTexture ) * tex2DNode3.r ) ) + ( ( _GreenColor * tex2DNode3.g ) + ( tex2DNode3.g * tex2D( _GreeenTexture, uv_GreeenTexture ) ) ) + ( ( _BlueColor * tex2DNode3.b ) + ( tex2D( _BlueTexture, uv_BlueTexture ) * tex2DNode3.b ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;50;1906;968;5121.268;1599.012;2.347954;True;False
Node;AmplifyShaderEditor.CommentaryNode;131;-2692.219,-1666.103;Inherit;False;770.5874;1404.842;Albedo;4;18;127;128;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;130;-3757.124,-407.0239;Inherit;False;715.2485;280;SplatMap;1;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;129;-2686.79,-719.4563;Inherit;False;552.3794;440.5089;Blue Mask;5;119;120;125;126;154;;0.7843137,0.7843137,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-2684.788,-1163.948;Inherit;False;567.1301;438.1165;Green Mask;5;14;124;123;7;153;;0.7843137,1,0.7843137,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-2686.219,-1608.103;Inherit;False;579.1315;441.115;Red Mask;5;13;121;122;5;152;;1,0.7843137,0.7843137,1;0;0
Node;AmplifyShaderEditor.SamplerNode;122;-2653.287,-1352.988;Inherit;True;Property;_RedTexture;Red Texture;1;1;[Header];Create;True;1;Red Channel;0;0;False;0;False;-1;None;8fe0c40253e5a384aa638901d5bfba22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-3707.125,-357.024;Inherit;True;Property;_SplatMap;SplatMap;0;1;[Header];Create;True;1;SplatMap;0;0;False;0;False;-1;None;14287068bc3eabb409de395776697167;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;123;-2662.058,-901.8317;Inherit;True;Property;_GreeenTexture;Greeen Texture;4;1;[Header];Create;True;1;Green Channel;0;0;False;0;False;-1;None;c4aabfd73502faf4d8efd9929fa474a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;125;-2644.804,-475.3303;Inherit;True;Property;_BlueTexture;Blue Texture;7;1;[Header];Create;True;1;Blue Channel;0;0;False;0;False;-1;None;9b6036f3ce39dba41b1b229d0c42f369;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;148;-2695.815,-221.5107;Inherit;False;626.1982;628.0737;Normals;7;146;141;147;137;149;150;151;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;119;-2628.99,-669.4563;Inherit;False;Property;_BlueColor;Blue Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-2624.788,-1127.948;Inherit;False;Property;_GreenColor;Green Color;6;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-2636.219,-1558.103;Inherit;False;Property;_RedColor;Red Color;3;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2429.045,-1553.143;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-2323.083,-471.9818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2362.5,-1310.746;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2435.624,-599.6287;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;137;-2645.815,-171.5107;Inherit;True;Property;_RedNormal;Red Normal;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;93cac3f08e842014cb8fedf5fd789e86;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2433.817,-1056.587;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;146;-2644.958,206.563;Inherit;True;Property;_BlueNormal;Blue Normal;8;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;7f6f78d4cdb0e824a9e3aeca1ab2a095;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;141;-2644.926,16.44965;Inherit;True;Property;_GreenNormal;Green Normal;5;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;e3149570907b3804986273dc9ed43a65;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-2357.414,-877.0194;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-2248.679,-628.8618;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-2359.83,241.0284;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-2351.481,-92.19476;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-2353.83,67.02844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-2236.33,-1441.719;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-2249.657,-1037.432;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-2047.749,-994.9632;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;147;-2206.616,45.31818;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1794.866,-345.5806;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ketcham1009/Halo 3/Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;5;0
WireConnection;13;1;3;1
WireConnection;154;0;125;0
WireConnection;154;1;3;3
WireConnection;152;0;122;0
WireConnection;152;1;3;1
WireConnection;120;0;119;0
WireConnection;120;1;3;3
WireConnection;14;0;7;0
WireConnection;14;1;3;2
WireConnection;153;0;3;2
WireConnection;153;1;123;0
WireConnection;126;0;120;0
WireConnection;126;1;154;0
WireConnection;151;0;146;0
WireConnection;151;1;3;3
WireConnection;149;0;137;0
WireConnection;149;1;3;1
WireConnection;150;0;3;2
WireConnection;150;1;141;0
WireConnection;121;0;13;0
WireConnection;121;1;152;0
WireConnection;124;0;14;0
WireConnection;124;1;153;0
WireConnection;18;0;121;0
WireConnection;18;1;124;0
WireConnection;18;2;126;0
WireConnection;147;0;149;0
WireConnection;147;1;150;0
WireConnection;147;2;151;0
WireConnection;0;0;18;0
WireConnection;0;1;147;0
ASEEND*/
//CHKSM=929EC9595561BE215360FEA25F6BF6BB3B92EC8E