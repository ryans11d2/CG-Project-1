Shader "Game/Laser"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) //Laser Colour
		_Scroll ("Scroll", Range(-1000, 1000)) = 1//Colour Offset
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
				fixed4 col = i.col;//Setup colour variable

				_Scroll *= _Time;//Scale scroll variable by time

				//Set colour based on pixel coordinates so colour fluxuates, add scroll for apearance of movement
				col *= 2 + sin((i.pos.x + i.pos.y + _Scroll) * 0.4);
				
				float pulse = sin(_Time * 100) / 2;//Set pulse (based on sin of time for value that raises and lowers)

				//If pulse is less than 0, set the reverse value insead, that way the value is always greater than 0
				pulse = sin(_Time * 100) / 2 > 0 ? pulse : -sin(_Time * 100) / 2;

				col *= pulse;//Multiply colour by pulse for fading effect

				return col;//Set fragment colour to vertex colour
			}

			ENDCG
		}

		
	}
}

