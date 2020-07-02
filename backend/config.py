# DATABASE_NAME = 'secure-private-dating'
# APP_ID = ''
# APP_SECRET = ''
# SESSION_TYPE = 'mongodb'

GIT_SERVER = 'git@vg100'

CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'

REPOS = {
    'p1': [
        {"name": "example-raw", "author": "Yihao Liu"},
        {"name": "example-create-elm-app", "author": "Yihao Liu"},
        {"name": "p1teamta", "author": "Shixin Song"},
        {"name": "p1teamta-new", "author": "Li Shi"},
        {"name": "p1teamta-sword", "author": "Yihao Liu"},
        {'name': 'p1team1', 'author': 'Xuye He,何叙烨, Qifei Wu,吴其非, Yi Xia,夏翌, siyuan lin 林思远'},
        {'name': 'p1team2', 'author': 'Zhehao Zhu 朱哲昊, Bokai Hu,胡博凯, Zihao Wei,魏子淏, Yidong Huang,黄奕东'},
        {'name': 'p1team3', 'author': 'Zefang Wei,危泽放, Danyu Zhou,周丹宇, Jigang Li,李济纲, Haifeng Jia,贾海峰'},
        {'name': 'p1team4', 'author': 'Yuxiang Zhou,周宇翔, Kaiwen Zhang,张凯文, Lan Wang,王澜, Yiming Zhang,章奕铭'},
        {'name': 'p1team5', 'author': 'Siyuan Kong,孔思原, Zhiyuan Chen,陈致远, Yulin Gao,高煜林, Yunheng Huang,黄云衡'},
        {'name': 'p1team6', 'author': 'Yi He,何一, Yiwei Ceng,曾亦炜, Hongxiao Zheng,郑鸿晓, Yuang Chen,陈煜昂'},
        {'name': 'p1team7', 'author': 'Wanqing Zhou,周莞卿, Zihang Song,宋子航, Yangyang Wang,王扬洋, Mingcheng Hu,胡铭程'},
        {'name': 'p1team8', 'author': 'AYSU ISMAYILOVA, Tianyu Lu,卢天宇, Baichuan Li,李百川, Yanmei Wang,王彦玫'},
        {'name': 'p1team9', 'author': 'Xingran Shen,沈行然, Jia Zhu,祝嘉, Yuqi Xie,谢雨齐, Yang Chen,陈旸'},
        {'name': 'p1team10', 'author': 'Baiqi Liu,刘柏琦, Yunzhen Liu,刘蕴臻, Yu Xia,夏羽, Shuyuan Yang,杨书媛'},
        {'name': 'p1team11', 'author': 'Jingjie Wan,万婧捷, Shuhui Yang,杨舒惠, Zixuan Pan,潘子瑄, Yifan Chen,陈一凡'},
        {'name': 'p1team12', 'author': 'Zihao Xu,徐梓豪, Chengfan Li,李乘帆, Yiwen Yang,杨毅文, Kaixin Shen,沈恺欣'},
        {'name': 'p1team13', 'author': 'Jinyi Wu,吴锦仪, Yunfei Li,李云飞, Yi Wang,王奕, Pingbang Hu,胡平邦'},
        {'name': 'p1team14', 'author': 'Yuwangzi Luo,罗雨王子, Lechen Zhang,张乐宸, Tianyue Li,李天越, Ruiqi Lai,赖睿奇'},
        {'name': 'p1team15', 'author': 'Kan Zhu,朱侃, Hongxi Tang,汤弘郗, Guanhua Xue,薛冠华, Haoran Jin,靳淏然'},
        {'name': 'p1team16', 'author': 'ASDA NAPAWAN, Sen Wang,王森, Taoran Ji,纪陶然, Yichen Cai,蔡易辰, Weizhen Jin,金唯真'},
        {'name': 'p1team17', 'author': 'Zheyu Zhang,张哲宇, Zhaoyue Yang,杨兆越, Zhan Wang,王湛, Liyan Jiang,蒋立言'},
        {'name': 'p1team18', 'author': 'Zhimin Sun 孙智敏, Yuchen Zhou,周昱辰, Rundong Tang,唐润东, Yuchen Jiang,姜宇辰'},
    ],
    'p2': [
        {"name": "example-raw", "author": "Yihao Liu"},
        {"name": "example-create-elm-app", "author": "Yihao Liu"},
        {'name': 'p2team1', 'author': 'Qifei Wu,吴其非, siyuan lin 林思远, Zihao Wei,魏子淏, Yidong Huang,黄奕东'},
        {'name': 'p2team2', 'author': 'Jingjie Wan,万婧捷, Xuye He,何叙烨, Yi Xia,夏翌, Shuhui Yang,杨舒惠'},
        {'name': 'p2team3', 'author': 'Zefang Wei,危泽放, Danyu Zhou,周丹宇, Jigang Li,李济纲, Haifeng Jia,贾海峰'},
        {'name': 'p2team4', 'author': 'Yuxiang Zhou,周宇翔, Kaiwen Zhang,张凯文, Lan Wang,王澜, Yiming Zhang,章奕铭'},
        {'name': 'p2team5', 'author': 'Siyuan Kong,孔思原, Zhiyuan Chen,陈致远, Yulin Gao,高煜林, Yunheng Huang,黄云衡'},
        {'name': 'p2team6', 'author': 'Yi He,何一, Yiwei Ceng,曾亦炜, Hongxiao Zheng,郑鸿晓, Yuang Chen,陈煜昂'},
        {'name': 'p2team7', 'author': 'Wanqing Zhou,周莞卿, Zihang Song,宋子航, Yangyang Wang,王扬洋, Mingcheng Hu,胡铭程'},
        {'name': 'p2team8', 'author': 'AYSU ISMAYILOVA, Tianyu Lu,卢天宇, Baichuan Li,李百川, Yanmei Wang,王彦玫'},
        {'name': 'p2team9', 'author': 'Xingran Shen,沈行然, Jia Zhu,祝嘉, Yuqi Xie,谢雨齐, Yang Chen,陈旸'},
        {'name': 'p2team10', 'author': 'Baiqi Liu,刘柏琦, Yunzhen Liu,刘蕴臻, Yu Xia,夏羽, Shuyuan Yang,杨书媛'},
        {'name': 'p2team11', 'author': 'Zhehao Zhu 朱哲昊, Zixuan Pan,潘子瑄, Bokai Hu,胡博凯, Yifan Chen,陈一凡'},
        {'name': 'p2team12', 'author': 'Zihao Xu,徐梓豪, Chengfan Li,李乘帆, Yiwen Yang,杨毅文, Kaixin Shen,沈恺欣'},
        {'name': 'p2team13', 'author': 'Jinyi Wu,吴锦仪, Yunfei Li,李云飞, Yi Wang,王奕, Pingbang Hu,胡平邦'},
        {'name': 'p2team14', 'author': 'Yuwangzi Luo,罗雨王子, Lechen Zhang,张乐宸, Tianyue Li,李天越, Ruiqi Lai,赖睿奇'},
        {'name': 'p2team15', 'author': 'Kan Zhu,朱侃, Hongxi Tang,汤弘郗, Guanhua Xue,薛冠华, Haoran Jin,靳淏然'},
        {'name': 'p2team16', 'author': 'ASDA NAPAWAN, Sen Wang,王森, Taoran Ji,纪陶然, Yichen Cai,蔡易辰, Weizhen Jin,金唯真'},
        {'name': 'p2team17', 'author': 'Zheyu Zhang,张哲宇, Zhaoyue Yang,杨兆越, Zhan Wang,王湛, Liyan Jiang,蒋立言'},
        {'name': 'p2team18', 'author': 'Zhimin Sun 孙智敏, Yuchen Zhou,周昱辰, Rundong Tang,唐润东, Yuchen Jiang,姜宇辰'}
    ]
}
