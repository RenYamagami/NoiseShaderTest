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

            float rings(float2 p){
				return sin(length(p)*100);
			}
            
            fixed4 frag (v2f i) : SV_Target
            {
            float scale =0.69;
               	float s = _Time*2;

				float uvX = (i.uv.x)*cos(scale)+(i.uv.y)*sin(scale)-0.5;
				float uvY = -(i.uv.x)*sin(scale)+(i.uv.y)*cos(scale);


                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                float2 p = i.uv;
				float indexX = floor(Circle(p)*0.1);
				float indexY = floor(Circle(p)*0.1);


				p.y += indexX*0.1f*-abs(sin(s)) ;
				p.x += indexY*0.1f*-abs(sin(s));
				//p.x += Circle(float2(newP));
				//p.y += sin(_Time);
				//p.y += cos(_Time);


	              //  fixed4 col2 = tex2D(_MainTex, lerp(i.uv,p+float2(0.5,0.5),abs(sin(s))));
	               	                fixed4 col2 = col+tex2D(_MainTex, p);

               // return fixed4(lerp(col,col2,sin(s)));

               return col2;
                }

                 
            
            ENDCG
        }
    }
}