# IMYViewCache

对View进行缓存  加块View初始化速度。 UITableViewCell 用处最大

QQ群号 113767274  有什么问题或者改进的地方大家一起讨论

	使用 5s 测试
	
	no_cache 加载时间:0.005371
	no_cache 加载时间:0.003294
	no_cache 加载时间:0.003582
	
	cache 加载时间:0.000275
	cache 加载时间:0.000232
	cache 加载时间:0.000233
	
	差不多会差10倍
	
	4s 测试
	
	no_cache 加载时间:0.007064
	no_cache 加载时间:0.006878
	no_cache 加载时间:0.006625
	
	cache 加载时间:0.000315
	cache 加载时间:0.000338
	cache 加载时间:0.000314
	
	虽然 0.001 的单位。 肉眼是感觉不出来的  但是如果界面一旦复杂起来,cell数量一多,机型更破  优化的效果会更明显

------------------------------------

## Requirements
* iOS 5.0+ 
* ARC only

## Adding to your project

	pod 'IMYViewCache', :head

## Basic usage
 
 1 .  use `IMYViewCacheManager` register view class

 ```objective-c
	[[IMYViewCacheManager shareInstance] registerClass:[IMYEBBrandSingleCell class]];
```		

 2 .  replace view initialization method
 
```objective-c
	-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMYEBBrandSingleCell* cell = [[IMYViewCacheManager shareInstance] instanceForClass:[IMYEBBrandSingleCell class] tableView:tableView];
    return cell;
}
```

3 . OK
 	
 		
 
 		
 		
