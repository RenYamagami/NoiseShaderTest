Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float Circle(float2 p){
				p*= 10.0;

				return ((p.x*p.x+p.y*p.y)-10);
			}
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float rand(float3 co)
{
return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
}

            float rings(float2 p){
				return sin(length(p)*100);
			}

			float noise(float3 pos)
{
float3 ip = floor(pos);
float3 fp = smoothstep(0, 1, frac(pos));
float4 a = float4(
rand(ip + float3(0, 0, 0)),
rand(ip + float3(1, 0, 0)),
rand(ip + float3(0, 1, 0)),
rand(ip + float3(1, 1, 0)));
float4 b = float4(
rand(ip + float3(0, 0, 1)),
rand(ip + float3(1, 0, 1)),
rand(ip + float3(0, 1, 1)),
rand(ip + float3(1, 1, 1)));
a = lerp(a, b, fp.z);
a.xy = lerp(a.xy, a.zw, fp.y);
return lerp(a.x, a.y, fp.x);
}

			float perlin(float3 pos){
			return 
(noise(pos) +
noise(pos * 2 ) +
noise(pos * 4) +
noise(pos * 8) +
noise(pos * 16) +
noise(pos * 32) ) / 6;
}
            
            fixed4 frag (v2f i) : SV_Target
            {
            float scale =0.69;
               	float s = _Time*30;

				float uvX = (i.uv.x-0.5)*cos(s)+(i.uv.y-0.5)*sin(s);
				float uvY = -(i.uv.x-0.5)*sin(s)+(i.uv.y-0.5)*cos(s);


                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                float2 p = i.uv;
				float indexX = floor((perlin(float3(i.uv.x,i.uv.y,1))-float2(0.5,0.5))*0.1);
				float indexY = floor(perlin(float3(i.uv.x,i.uv.y,1))*0.1);

				p.x += indexX*0.05f;
				p.y += indexY*0.05f;




	              //  fixed4 col2 = tex2D(_MainTex, lerp(i.uv,p+float2(0.5,0.5),abs(sin(s))));
	            fixed4 col2 = tex2D(_MainTex, p);

               // return fixed4(lerp(col,col2,sin(s)));

               return col2;
                }

                 
            
            ENDCG
        }
    }
}