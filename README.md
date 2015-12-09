# IMYViewCache

对View进行缓存  预加载UIView，提高界面切换速度。 支持全局UITableViewCell复用

QQ群号 113767274  有什么问题或者改进的地方大家一起讨论

	使用 5s 测试
	
	no_cache 加载时间:0.002630
	no_cache 加载时间:0.001345
	no_cache 加载时间:0.001508
	
	cache 加载时间:0.000082
	cache 加载时间:0.000048
	cache 加载时间:0.000042
	
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
 +(void)load
{
    [UITableView imy_registerClass:[IMYEBBrandSingleCell class] nib:[UINib nibWithNibName:@"IMYEBBrandSingleCell" bundle:nil] reuseIdentifier:@"IMYEBBrandSingleCell" cacheCount:8];
}
and 
	UITableView *tableView = [new];
	...
    tableView.imy_usingViewCache = YES;
```		

 2 .  replace view initialization method
 
```objective-c
    IMYEBBrandSingleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IMYEBBrandSingleCell"];
```

3 . OK
 	
 		

