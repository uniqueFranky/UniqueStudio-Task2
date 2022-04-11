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
