# Weather Forecast

一个使用 Objective-C 和 UIKit 开发的 iOS 天气应用。项目通过 WeatherAPI 获取城市搜索、实时天气、小时预报、多日预报、空气质量、日出日落和月相等数据，并根据天气状态切换图标和背景图。

## 功能

- 首页城市天气列表
- 城市关键词搜索和联想结果
- 支持点击键盘 Search/回车直接进入第一个匹配城市详情页
- 当前温度、天气状态、最高温和最低温展示
- 小时天气预报
- 7 天天气预报
- 空气质量、紫外线、体感温度、风、湿度、日出日落、月相等天气卡片
- 根据天气 code 映射 SF Symbols 图标和背景图片
- 支持编辑已保存城市列表

## 技术栈

- Objective-C
- UIKit
- Masonry 自动布局
- NSURLSession 网络请求
- WeatherAPI 天气接口和城市搜索接口
- LookinServer 调试工具

## 环境要求

- iOS 13.0+
- Xcode
- CocoaPods

## 运行方式

1. 安装依赖：

   ```sh
   pod install
   ```

2. 打开 workspace：

   ```sh
   open "Weather Forecast.xcworkspace"
   ```

3. 在 Xcode 中选择 `Weather Forecast` target，构建并运行。

## 项目结构

```text
Weather Forecast/
  Home/                 首页、城市列表、城市搜索
  CityDetail/           城市天气详情页和天气卡片 UI
  Assets.xcassets/      天气背景图、图标和图片资源
  WeatherData.*         WeatherAPI 网络请求封装
  WeatherModel.*        天气数据模型、解析、图标和背景映射
```

## 注意事项

- 当前 WeatherAPI key 写在 `WeatherData.m` 源码中。
- 空气质量数据需要 forecast 请求携带 `aqi=yes`。
- 项目使用 CocoaPods，请打开 `.xcworkspace`，不要直接打开 `.xcodeproj`。
