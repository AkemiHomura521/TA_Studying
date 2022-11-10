Shader "Shader/001"
{
    Properties
    {
		_Int ("Int", int) = 2							//int类型声明
		_Float("Float", float) = 1.5					//float类型声明
		_Range("Range",range(0,2)) = 1					//滑动条范围声明
		_Cube("Cube",cube) = "White"{}					//Cube变量声明，天空盒
		_Color("Color",color) = (0,0,0,0)				//颜色变量声明
		_Vector("Vector",vector) = (0,0,0,0)			//四元数变量声明
		_3D("3D",3D)="black"{}							//3D变量声明，了解即可
        _MainTex ("Texture", 2D) = "white" {}			//2d贴图变量声明
    }
    SubShader
    {
        Tags //在外面定义则所有Pass通道都应用这套Tags，未定义的则可以在Pass通道内定义
		{ 
			"Queue"="Transparent"						//渲染顺序
			"RenderType"="Opaque"						//着色器替换功能
			"DisableBatching"="False"					//是否关闭合批
			"ForceNoShadowCasting"="True"				//是否投射阴影
			"IgnoreProjector"="True"					//是否受Projector影响，projector是用于投射阴影的，通常用于不透明物体
			"CanUseSpriteAltas"="False"					//是否用于图片的shader，通常用于UI
			"PreviewType"="Plane"						//用作shader的预览类型
		}

		//Render设置，可选
		//Cull back							//off为双面渲染，back为正面渲染，front为背面渲染   //选择渲染面
		//ZTest Always						// Always/Less Greater/LEqual/GEqual/Equal/NotEqual  以上为深度测试
		//Zwrite off						// off/on 是否开启深度写入
		//Blend SrcFactor DstFactor			//混合
        LOD 100								//不同情况下使用不同LOD，达到性能提升

        Pass
        {
			Name "Default"					//pass通道名称
			Tags//可以在每个pass通道内进行设置，如果与外面的重复，则优先使用外面的
			{
				"LightMode"="ForwardBase"				//光照模型，定义该pass通道在unity流水中的角色
				"RequireOptions"="SoftVegetation"		//满足条件才能渲染该通道
			}

			//CG语言所写的代码，用于顶点片元着色器
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
