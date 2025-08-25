#  App Store 上架相关

### 字符串本地化
一. App 内部文本
把我们的文案 (按钮标题, app 内的展示文本), 去做一个翻译工作, 为了给全球的用户来使用, 如果只给国内用户使用的 app, 可以先不用管

具体操作: 
1. 去项目中配置需要适配的语言版本 (e.g. 中文, 英文, 法文等)
2. 创建一个文件 `Localizable` 的 strings 文件
3. 编译我们的项目 (command + b)
4. 去填写文本的其他语言版本

写代码需要注意的点: 
1. 如果用 String 去声明的变量比如 let name = "xxx", xcode 是不会自动生成的
2. 需要使用 let name: LocalizedStringKey = "xxx"  或者用 String(localized: "xxx") 来做
3. 使用 SwiftUI 的组件无需任何调整 Text("xxx")

二. App 的名字本地化
1. 创建一个 `InfoPlist` 的 strings 文件
2. 编译项目
3. 去填写其他语言版本

如果你的 App 名字和 xcode 创建的项目名一样, 那么直接本地化 CFBundleName 即可
如果你需要一个`艺名`, 好看的名字, 那么我们需要去项目中设置 CGBundleDisplayName (点击项目 -> Project -> Build Settings -> 搜 Display Name)
设置一个英文名称比如 xxx, 同时重复 2, 3, 同时清空 CFBundleName

### 2. 制作我们的 App 图标
一、制作 iOS 18 以及之前的图标
每个应用都有自己的图标, 利用 Figma 来制作图标, iOS26 图标制作, iOS26 之前的图标, 如果我们 app 版本支持 iOS 18, 17 之类的需要单独制作

1. 去 Figma 中搜索 app icon template 
    模版文件: 
        `App Store / Play Store Preview Templates / Icon generator` (三方)
        `iOS 18 and iPadOS 18 App Icon Template` (官方)
2. 打开模版文件, 替换默认图标为我们的图片
    图片获取方式: 1. 自己画, 2. 去网站/图标库找 (icons8, SF Symbols), 3. 用 AI 生成 (可以提前找到参考图丢给 AI, 让 AI 去重新设计风格)
3. 

二、制作 iOS 26 的图标
1. 需要去 https://developer.apple.com/download/applications/ 下载 Icon Composer 和 Xcode beta
2. 去下载 iOS 26 的图标线框图
3. 去 Figma 中按照新的线框图来设计 Icon 的图层 (⚠️: 图标图层的宽高不能带有小数, 否则模拟器渲染会有问题)
4. 将图层导入到 Icon Composer 中, 做调整 (比如背景颜色, 其他主题下的图标颜色等) 
    更多建议资料: https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer
5. 使用 Icon Composer 导出图标, 并拖入到 Xcode (⚠️: 导出的名字一定是 `AppIcon`)

### 3. App 截屏素材
使用 Figma 来制作截屏素材
1. 直接使用 App 内部的截屏
    优点: 比较简单, 直接从 iPhone 中截图上传到 App Store 即可
    缺点: 对用户来说可能不太直观, 第一眼看上去不知道是什么页面
    
2. 使用标题 + 描述 + 截屏 (或者带 iPhone 边框) + 背景
    优点: 比较好看, 可以自己制作不同的样式, 吸引用户的眼球, 有标题 + 描述可以清晰的告诉用户这个页面是做什么的
    缺点: 稍微麻烦一点, 需要我们自己制作, 或者利用工具制作
    
    制作方法: 
        1. 使用 Figma (iPhone 边框搜索: iOS 26 (使用苹果官方的组件))
        2. 使用一些工具 (https://screenshots.pro)
    
对于第一种方式, App Store 之前要求上传两种尺寸的截图, 比如 6.9 和 6.5 英寸 (需要截图 2 次, 很麻烦)
第二种可以截图一次, 然后给他加背景, 同时使用工具导出 2 种尺寸

App Store 发布页面: https://appstoreconnect.apple.com/
App 数据分析网站: https://app.diandian.com/

### 4. 一些宣传文案
如何利用 AI 工具, 生成我们的宣传文案 (之前没有 AI 的时候, 我们需要自己写, 抄别人的文案等等)

如何使用 fastlane 来快速填写 app 信息
1. 安装 Homebrew: https://brew.sh/ (粘贴官网的命令到 Terminal/Cursor 中)
2. 使用 Homebrew 安装 fastlane: `brew install fastlane`
3. 对我们的项目初始化 fastlane (每个项目都需要做初始化 fastlane 的操作)
    fastlane init
4. 添加一个新的命令到 Fastlane 文件中
    desc "Sync local metadata to App Store Connect"
        lane :sync_metadata do
        deliver(
            skip_binary_upload: true,
            skip_screenshots: true,
            force: true,
            overwrite_screenshots: false
        )
    end
5. 更新 metadata/ 文件夹下不同的语言内容
6. 调用 fastlane sync_metadata

### 5. App 定价
免费, 一次性付费, 有内购 (订阅, 一次性买断) 等

### 6. 提交审核

### 7. 备案
如果你的 App 要上架到国区, 那么需要备案
