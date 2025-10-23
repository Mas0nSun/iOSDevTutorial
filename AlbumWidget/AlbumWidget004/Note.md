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
    - Apple Music 授权逻辑 
    
### 首页: 
    1. 新手引导
    2. 导入/添加 Widget
    3. 小组件预览 List
    4. Mini 播放器
    
### 内购: 解锁付费功能

### 新建/编辑 Widget: 允许用户自定义 Widget 的展示 UI

### 用户帮助页面: 一些常见的问题分析 + 新手引导

### 搜索音乐: 搜索 Apple Music 中的歌曲/专辑


## Widget 核心功能

### 数据同步: 允许用户在 App 内添加数据, 在 Widget 中可选择已配置的数据

### UI 绘制

### 支持动态配置 Widget

