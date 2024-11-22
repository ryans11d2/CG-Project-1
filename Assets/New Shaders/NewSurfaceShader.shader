Shader "aer"
{
	Properties {
		_myColor ("Sample Color", Color) = (1,1,1,1)
		_addColor ("Add Color", Color) = (0.1,0.1,0.1,1)
		_myRange ("Sample Range", Range(0, 5)) = 1
		_myTex ("Sample Texture", 2D) = "white" {}
		_myCube ("Sample Cube", Cube) = "" {}
		_myFloat ("Sample Float", Float) = 0.5
		_myVector ("Saple Vector", Vector) = (0.5, 1, 1, 1)

		//_myDiffuse ("Diffuse Texture", 2D) = "white" {}
		//_myBump ("Bump Texture", 2D) = "bump" {}
		//_mySlider ("Bump Amount", Range(0,10)) = 1

	}
	SubShader {

		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _myColor;
		half _myRange;
		sampler2D _myTex;
		samplerCUBE _myCube;
		float _myFloat;
		float4 _myVector;

		//sampler2D _myDiffuse;
		//sampler2D _myBump;
		//half _mySlider;

		struct Input {
			float2 uv_myTex;
			float3 worldRefl;

			//float2 uv_myDiffuse;
			//float2 uv_myBump;
		};

		void surf (Input IN, inout SurfaceOutput o){
			o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange).rgb + _myColor;
			o.Emission = texCUBE (_myCube, IN.worldRefl).rgb + _myColor;

			//o.Albedo += tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
			//o.Normal = tex2D(_myDiffuse, IN.uv_myBump);
			//o.Normal *= float3(_mySlider,_mySlider,1);
		}
		ENDCG

	}
	FallBack "Diffuse"
}