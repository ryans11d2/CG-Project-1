Shader "Game/Laser"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) // Default to red
		_Scroll ("Scroll", Range(-1000, 1000)) = 1
		_MainTex ("Texture", 2D) = "white" {}
		_Dir ("Direction", float) = 1
	}

	SubShader
	{

		Tags {"LightMode" = "ForwardBase"}
	
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			sampler2D _MainTex;
			float _Scroll;

			uniform float4 _LightColor0;


			struct vertexInput//vertexInput component
			{
				float4 vertex: POSITION;//Vertex position
				float3 normal: NORMAL;//Vertec normal
			};

			struct vertexOutput//vertexOutput component
			{
				float4 pos: SV_POSITION;//Vertex position
				float4 col: COLOR;//Vertex colour
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;//o has the pos and col col variables of vertexOutput
				
				//Calculate output o variables using input v information and return o
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = 1.0;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				//Calculate diffuse reflection using normal and light direction gathered above
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

				o.col = float4(lightFinal * _Color.rgb, 1.0);//Set o color
				o.col = _Color;

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{	
				fixed4 col = i.col;

				_Scroll *= _Time;

				col *= 2 + sin((i.pos.x + i.pos.y + _Scroll) * 0.4);
				
				float pulse = sin(_Time * 100) / 2;

				pulse = sin(_Time * 100) / 2 > 0 ? pulse : -sin(_Time * 100) / 2;

				col *= pulse;

				return col;//Set fragment colour to vertex colour
			}

			ENDCG
		}

		
	}
}

