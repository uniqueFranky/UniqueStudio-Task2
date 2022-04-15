# UniqueStudio Task2

## 2022.4.9
 * 确定了一下思路

## 2022.4.10
 * 在present的时候遇到了不少的问题，比如present似乎有一个延迟，在执行完present后面的语句以后才会显示新的页面。
 * 本来没打算把Picker写成一个ViewController的，但是发现Delegate必须是NSObject，所以就先把Picker写成ViewController，之后再想办法改一改
 * 在写Cropper的时候，被如何显示框外的内容困扰了好久，最后才发现只用把clipToBound改成false就行了
 * 竖屏照片在crop之后会被旋转，上网找了一下解决方法，发现有个霉B和我有一样的问题。解决方案还没看太懂，不过大概就是按照orient旋转图片之后再crop
 * 还有一个问题，就是因为present的延迟，直接在present PickerView之后获取照片是不可行的，必须要让用户再发出一个指令。这个问题也许和我把Picker写成了ViewController有关系，如果Picker不需要present的话，可能就可以解决了。

## 2022.4.11
 * 今天突然发现可以不用present ImagePicker
 * 之前的延迟问题好像可以用delegate解决，裁剪完成后直接调用delegate的方法就行了。这个打算等到写完从图库选择照片以后再重构一下。
 * 看了点PhotoKit的doc

## 2022.4.12
 * 基本实现了从相册选择照片，但是还有一些细节没有实现，比如用户更新权限后不能自动刷新列表、不能让用户手动更改可访问的范围。
 * 通过callback实现了不用用户手动点击“获取图片”
 * 实现更改权限的时候，找不到官方文档里的presentLimitedLibraryPicker(from:)这个函数，明天再想办法吧

## 2022.4.13
 * presentLimitedLibraryPicker(from:)要import PhotosUI
 * 更改limited照片范围后可以刷新，但是第一次打开应用授权以后不能自动刷新
 * 从图库获取的照片的清晰度比较低，用opts.deliveryMode = .highQualityFormat解决了

## 2022.4.14
 * 可以通过在ViewController里先申请权限，但这样一打开app就会被要求授予相册权限，好像不太好
 * 尝试用DispatQueue先请求权限，再加载CollectionView，但是好像请求权限在用户授权之前就会返回，失败。

## 2022.4.15
 * 用PHPhotoLibraryChangeObserver实现了授权之后的自动刷新
 * 添加了保存到相册的功能
 * 查资料发现，UIKit calls必须在main thread上，可以通过DispathQueue.main.async/sync实现
