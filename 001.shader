Shader "Shader/001"
{
    Properties
    {
		_Int ("Int", int) = 2							//int��������
		_Float("Float", float) = 1.5					//float��������
		_Range("Range",range(0,2)) = 1					//��������Χ����
		_Cube("Cube",cube) = "White"{}					//Cube������������պ�
		_Color("Color",color) = (0,0,0,0)				//��ɫ��������
		_Vector("Vector",vector) = (0,0,0,0)			//��Ԫ����������
		_3D("3D",3D)="black"{}							//3D�����������˽⼴��
        _MainTex ("Texture", 2D) = "white" {}			//2d��ͼ��������
    }
    SubShader
    {
        Tags //�����涨��������Passͨ����Ӧ������Tags��δ������������Passͨ���ڶ���
		{ 
			"Queue"="Transparent"						//��Ⱦ˳��
			"RenderType"="Opaque"						//��ɫ���滻����
			"DisableBatching"="False"					//�Ƿ�رպ���
			"ForceNoShadowCasting"="True"				//�Ƿ�Ͷ����Ӱ
			"IgnoreProjector"="True"					//�Ƿ���ProjectorӰ�죬projector������Ͷ����Ӱ�ģ�ͨ�����ڲ�͸������
			"CanUseSpriteAltas"="False"					//�Ƿ�����ͼƬ��shader��ͨ������UI
			"PreviewType"="Plane"						//����shader��Ԥ������
		}

		//Render���ã���ѡ
		//Cull back							//offΪ˫����Ⱦ��backΪ������Ⱦ��frontΪ������Ⱦ   //ѡ����Ⱦ��
		//ZTest Always						// Always/Less Greater/LEqual/GEqual/Equal/NotEqual  ����Ϊ��Ȳ���
		//Zwrite off						// off/on �Ƿ������д��
		//Blend SrcFactor DstFactor			//���
        LOD 100								//��ͬ�����ʹ�ò�ͬLOD���ﵽ��������

        Pass
        {
			Name "Default"					//passͨ������
			Tags//������ÿ��passͨ���ڽ������ã������������ظ���������ʹ�������
			{
				"LightMode"="ForwardBase"				//����ģ�ͣ������passͨ����unity��ˮ�еĽ�ɫ
				"RequireOptions"="SoftVegetation"		//��������������Ⱦ��ͨ��
			}

			//CG������д�Ĵ��룬���ڶ���ƬԪ��ɫ��
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
	FallBack Off				//  "Legacy Shaders/Transparent/VertexLit/off"  
}
