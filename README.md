# privateApiApps

私有API是指苹果未公开的一些方法，通常情况下这些方法不允许开发者使用，通常情况是指上架AppStore。私有API可以实现一些开放API不能实现的效果，功能强大，效果非凡。苹果不允许使用，是因为有些私有API会侵犯用户隐私，但使用私有API也并非一定会侵犯用户隐私，这要看开发者怎么用了。

企业级账号发布供内部人使用的APP，可以使用私有API。发布到其他APP平台供越狱手机下载的APP，也有可能使用了私有API。这两者没有苹果审核把关，私有API可以随便使用。**苹果明令禁止使用私有API的APP上架AppStore！**但凡事无绝对，AppStore上也不乏使用私有API的应用，使用办法有很多，比如热更新。不被苹果发现就行，发现了轻者下架，重者封号。

我想看看私有API到底能干些啥，写了一个测试私有API的小项目，涉及到的知识点大多数来源于网络，在此感谢大神们的知识共享。项目很小，知识很浅，欢迎拍砖吐槽。

项目截图:

![获取iPhone上的所有APP](http://oalg33nuc.bkt.clouddn.com/WechatIMG241.jpeg)

![APP相关信息](http://oalg33nuc.bkt.clouddn.com/WechatIMG242.jpeg)

开发环境: Xcode 8.2.1，iPhone 6，iOS 10.2

参考资料:

1. [iOS-Runtime-Headers](https://github.com/nst/iOS-Runtime-Headers)
2. [获取iOS设备上安装的应用列表](http://octree.me/2016/08/01/get-installed-apps/)

## 获取iPhone中安装的APP列表

```Objective-C
Class LSAppClass = objc_getClass("LSApplicationWorkspace");
NSObject *workspace = [LSAppClass performSelector:@selector(defaultWorkspace)];
NSArray *appsArray = [workspace performSelector:@selector(allApplications)];
```

这里面使用了runtime的方法`- (id)performSelector:(SEL)aSelector;`，需要引入`<objc/runtime.h>`。该方法的作用是给接收者传递进去一个方法，返回值就是这个方法执行后的返回值。

由于调用的是私有API，传入的方法相当于一个字符串，编译器不会检测该方法是否正确，相反会一直报警告。例如上面传递的方法`defaultWorkspace`，这是个私有API的方法。通常还有另一种调用`performSelector`方法的写法：

```Objective-C
NSObject *workspace = [LSAppClass performSelector:NSSelectorFromString(@"defaultWorkspace")];
```

如果传递进去的私有API方法名写错了，程序就会找不到该方法而崩溃。所以通常会通过下面方法检测接收者或接收者的父类是否实现了传递进去的方法。

```Objective-C
- (BOOL)respondsToSelector:(SEL)aSelector;
```

使用方法：

```Objective-C
if ([LSAppClass respondsToSelector:@selector(defaultWorkspace)]) {
   	NSObject *workspace = [LSAppClass performSelector:@selector(defaultWorkspace)];
}
```

真实情况中，该方法并非必要。传入的私有API方法名都是固定的，程序崩溃了说明方法名写错了，改成正确的即可。使用该方法不会崩溃，反而不易发现错误。

## 获取每个APP的相关信息

```Objective-C
[appsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {   
	AppsObject *appsObj = [[AppsObject alloc] init];
	appsObj.appName = [obj performSelector:@selector(localizedName)];
	appsObj.version = [obj performSelector:@selector(shortVersionString)];
	appsObj.bundleId = [obj performSelector:@selector(applicationIdentifier)];
	appsObj.appFullName = [obj performSelector:@selector(itemName)];
	appsObj.appType = [obj performSelector:@selector(applicationType)];
	appsObj.appVendorName = [obj performSelector:@selector(vendorName)];
	appsObj.appRating = [obj performSelector:@selector(ratingLabel)];
	[_appsObjArray addObject:appsObj];
}]
```

遍历获取的APP列表，通过私有API获取每个app的各种信息：

|私有API方法名|用途|
|:---|:---|
|localizedName|app名字|
|shortVersionString|版本号|
|applicationIdentifier|Bundle Identifier|
|itemName|app在AppStore显示的名字|
|applicationType|app类型,分为:System和User|
|vendorName|app供应商|
|ratingLabel|app评级|

## 获取APP图标

上述中并没有获取APP图标的方法，获取app图标比较麻烦。

### 获取APP图标路径

```Objective-C
NSDictionary *dict = [object performSelector:@selector(boundIconsDictionary)];
NSString *appIconPath = [NSString stringWithFormat:@"%@/%@.png",[[object performSelector:@selector(resourcesDirectoryURL)] path],[[[dict objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] lastObject]];
```

iOS10.2亲测，该方法只能获取模拟器上的APP图标，真机无效。

### 获取图标data数据

```Objective-C
appsObj.iconData = [obj performSelector:@selector(iconDataForVariant:) withObject:@(2)];
```

该data数据并不能直接转为UIImage，需要对data数据进行截取转换，方法如下：

```Objective-C
+ (UIImage *)getAppIcon:(NSData *)iconData {
    NSInteger lenth = iconData.length;
    NSInteger width = 87;
    NSInteger height = 87;
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    [iconData getBytes:pixels range:NSMakeRange(32, lenth - 32)];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, (width + 1) * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    UIImage *icon = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    return icon;
}
```

## 打开APP

在iOS 9以后要想打开其他app需要添加URL Scheme，设置白名单，否则将无法打开，白名单的上限为50个。上文中我们可以获取APP的`Bundle Id`，依靠`Bundle Id`使用私有API可以打开其他APP，并没有数量限制。

```Objective-C
Class LSAppClass = NSClassFromString(@"LSApplicationWorkspace");
id workSpace = [(id)LSAppClass performSelector:@selector(defaultWorkspace)];
[workSpace performSelector:@selector(openApplicationWithBundleID:) withObject:self.appsObj.bundleId];
```

