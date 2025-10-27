#  唱片小组件

## App 核心功能

### 引导页: 展示 App 的核心功能, 以及 Apple Music 授权
    - 欢迎页面 ✅
        - 顶部照片墙 ✅
        - 底部文本 + 按钮 ✅
    - 请求 Apple Music 权限页面 ✅
        - 顶部渐变背景 ✅
        - 底部文本 + 按钮 ✅
    - 欢迎页面的跳转逻辑: 点击 continue 跳转到 Music 页面 ✅
        (转场效果类似于导航的形式, 第一个页面向左侧小时, 第二个页面从右侧出现)
        --- 动画管理页面 (负责页面 1, 跳转到页面 2)
           --- 1. WelcomeView
           --- 2. MusicPermissionView
           --- 3. xxx
           --- 4. xxx
           
           
        --- App 主页面 (当展示过动画管理页后, 我们就可以不在展示它)
            --- Welcome 动画管理页面
        
        - 用户点击 apple music 按钮后, 让整个 onboarding 页面消失 ✅
    - Apple Music 授权逻辑 ✅
        - 如果你是新手, 不知道如何实现一个功能
            1. 去参考竞品 (App Store 上随便搜一些相关 app, 看他们怎么做的)
            2. 问 AI (GhatGPT, xxxx)
            3. 去 google, apple 官方文档 (查找相关内容)
            
    - 授权之后的逻辑 ✅
        1. 如果授权成功, 直接打开 App 主页面 (不再看到 welecome 页面)
        2. 如果授权失败, 提示用户打开 `设置` 去开启权限 (让用户看到 MusicPermissionView)
        
        用户从 welcome 页面点击授权后, 可以看到 welcome (onboarding) 页面消失的动画
        如果用户下次再打开 app 的时候, 已经授权过了, 就不展示 welcome (也就没有任何动画)
        
    - 目前授权成功后, welcome 消失的动画没有展示 ⚠️
    
### 首页: 
    1. 新手引导 
    2. 导入/添加 Widget
        - 搜索专辑/歌曲页面 (包含导航 + searchBar + 占位 UI (未搜索状态)) ✅
        - 搜索结果 UI (从左到右依次是唱片封面, 歌曲/唱片名称, 歌手名称) ✅
        - 绘制唱片卡片 UI ✅
        
        --- 添加 Widget 页面 
        - 增加底部按钮以及顶部 widget ✅
        - 添加是否展示 info 功能 (歌曲名称, 作者名) ✅
        - 支持切换 size
        - 支持切换 theme 
        - 实现创建 widget 功能, 点击创建按钮将 widget 保存
            总结: 
            --- 存储: 当用户创建一个 widget 时, 我们实际上是把 widget 卡片中的 UI 参数, 
                转换成了一个 model (数据结构), 同时将 model (XXXWidget) 编码成 Data 然后以文件的形式存储到手机沙盒中
            --- 加载: 从沙盒中获取到 file, 然后转换成 Data, 再解码成我们的 model (XXXWidget), 然后去把参数丢给我们的 AlbumWidgetView
                同时将 AlbumWidgetView 放到 App 首页里
                
                e.g: 其他类别的应用如 Todo, 笔记 (Note), 记账 (Record)
    3. 小组件预览 List
    4. Mini 播放器
    
    
    
    Bugs:
    1. 添加小组件的时候, 从搜索进入创建页面偶尔出现封面不展示的问题 ❗️❗️❗️
    
### 内购: 解锁付费功能

### 新建/编辑 Widget: 允许用户自定义 Widget 的展示 UI

### 用户帮助页面: 一些常见的问题分析 + 新手引导

### 搜索音乐: 搜索 Apple Music 中的歌曲/专辑


## Widget 核心功能

### 数据同步: 允许用户在 App 内添加数据, 在 Widget 中可选择已配置的数据

### UI 绘制

### 支持动态配置 Widget

