# WLPhotoViewer
一个简单的图片浏览库

![](7月 22 2015-16-34.gif)

使用方法：


<pre><code>-(void)clickButton:(UIButton *)button
{
    WLPhotoViewController *next = [WLPhotoViewController new];
    next.photos = self.photos;
    next.imgFrames = self.imageFrames;
    next.index = button.tag - 10;
    [next showFromController:self withButton:button buttonParentView:self.view];
}
</code></pre>
