//
//  IPubTaskDetailViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPubTaskDetailViewController.h"
#import "IPubTask.h"
#import "ITextView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <PYPhotoBrowser/PYPhotoBrowser.h>
#import <Toast/UIView+Toast.h>
#import "Utils.h"
#import "AFNRequestManager.h"
#import "iUser.h"

#define BACK_IMG [UIImage imageNamed:@"i_add_pic.png"]

@interface IPubTaskDetailViewController ()

@end

@implementation IPubTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    CGFloat vTop = [Utils isAboveIOS11] ? 0: - rNav.origin.y - rNav.size.height;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height)];
    [self.view addSubview:self.scrollView];
    
    NSDictionary *stepInfo = [[IPubTask shareInstance]getStepInfoByStep:self.step];
    NSDictionary *taskInfo = [IPubTask shareInstance].taskInfo;
    
    UILabel *basicInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + vTop, 200, 20)];
    basicInfo.font = [UIFont systemFontOfSize:13.0];
    basicInfo.text = @"基本信息";
    [self.scrollView addSubview:basicInfo];
    
    UIView *basicInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, vTop + 30, rScreen.size.width, 100)];
    basicInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:basicInfoView];
    
    UILabel *taskName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 15)];
    taskName.font = [UIFont systemFontOfSize:12.0];
    taskName.text = @"任务名称:";
    [basicInfoView addSubview:taskName];
    
    UILabel *taskNameText = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, rScreen.size.width - 70, 15)];
    taskNameText.font = [UIFont systemFontOfSize:12.0];
    taskNameText.textColor = [UIColor darkGrayColor];
    [basicInfoView addSubview:taskNameText];
    taskNameText.text = [NSString stringWithString:[taskInfo objectForKey:@"taskname"]];
    
    UILabel *serialNo = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 15)];
    serialNo.font = [UIFont systemFontOfSize:12.0];
    serialNo.text = @"任务批次:";
    [basicInfoView addSubview:serialNo];
    
    UILabel *serialNoText = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, rScreen.size.width - 70, 15)];
    serialNoText.font = [UIFont systemFontOfSize:12.0];
    serialNoText.textColor = [UIColor darkGrayColor];
    [basicInfoView addSubview:serialNoText];
    serialNoText.text = [NSString stringWithString:[stepInfo objectForKey:@"batchcode"]];
    
    UILabel *taskAddr = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 15)];
    taskAddr.font = [UIFont systemFontOfSize:12.0];
    taskAddr.text = @"任务地址:";
    [basicInfoView addSubview:taskAddr];
    
    UILabel *taskAddrText = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, rScreen.size.width - 70, 15)];
    taskAddrText.font = [UIFont systemFontOfSize:12.0];
    taskAddrText.textColor = [UIColor darkGrayColor];
    [basicInfoView addSubview:taskAddrText];
    taskAddrText.text = [NSString stringWithString:[stepInfo objectForKey:@"addr"]];

    UILabel *merchName = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 15)];
    merchName.font = [UIFont systemFontOfSize:12.0];
    merchName.text = @"商户名称:";
    [basicInfoView addSubview:merchName];

    UILabel *merchNameText = [[UILabel alloc] initWithFrame:CGRectMake(65, 60, rScreen.size.width - 70, 15)];
    merchNameText.font = [UIFont systemFontOfSize:12.0];
    merchNameText.textColor = [UIColor darkGrayColor];
    [basicInfoView addSubview:merchNameText];
    merchNameText.text = [NSString stringWithString:[stepInfo objectForKey:@"merchname"]];

    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 15)];
    shopName.font = [UIFont systemFontOfSize:12.0];
    shopName.text = @"门店名称:";
    [basicInfoView addSubview:shopName];
    
    UILabel *shopNameText = [[UILabel alloc] initWithFrame:CGRectMake(65, 80, rScreen.size.width - 70, 15)];
    shopNameText.font = [UIFont systemFontOfSize:12.0];
    shopNameText.textColor = [UIColor darkGrayColor];
    [basicInfoView addSubview:shopNameText];
    shopNameText.text = [NSString stringWithString:[stepInfo objectForKey:@"shopname"]];
    
    UILabel *stepIllustrate = [[UILabel alloc] initWithFrame:CGRectMake(10, basicInfoView.frame.origin.y + basicInfoView.frame.size.height + 5, 200, 20)];
    stepIllustrate.font = [UIFont systemFontOfSize:13.0];
    stepIllustrate.text = @"步骤说明";
    [self.scrollView addSubview:stepIllustrate];
    
    UILabel *stepTitle = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 500, stepIllustrate.frame.origin.y, 490, 20)];
    stepTitle.font = [UIFont systemFontOfSize:13.0];
    stepTitle.textAlignment = NSTextAlignmentRight;
    stepTitle.textColor = [UIColor redColor];
    stepTitle.text = [NSString stringWithString:[stepInfo objectForKey:@"stepname"]];
    [self.scrollView addSubview:stepTitle];
    
    UITextView *remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, basicInfoView.frame.origin.y + basicInfoView.frame.size.height + 30, rScreen.size.width, 40)];
    [remarkTextView setEditable:NO];
    remarkTextView.font = [UIFont systemFontOfSize:12.0];
    [remarkTextView setBackgroundColor:[UIColor whiteColor]];
    [remarkTextView setScrollEnabled:NO];
    [self.scrollView addSubview:remarkTextView];
    remarkTextView.text = [NSString stringWithString:[stepInfo objectForKey:@"remark"]];
    CGSize rcRemark = [remarkTextView sizeThatFits:CGSizeMake(remarkTextView.frame.size.width, FLT_MAX)];
    remarkTextView.py_height = rcRemark.height > 40.0f ? rcRemark.height : 40.0f;
    
    UILabel *inspContent = [[UILabel alloc] initWithFrame:CGRectMake(10, remarkTextView.frame.origin.y + remarkTextView.frame.size.height + 5, 100, 20)];
    inspContent.font = [UIFont systemFontOfSize:13.0];
    inspContent.text = @"巡检内容";
    [self.scrollView addSubview:inspContent];
    
    
    self.inspContentText = [[ITextView alloc] initWithFrame:CGRectMake(20, 10, rScreen.size.width - 40, 40)];
    [self.inspContentText setPlaceholder:@"请输入情况说明"];
    [self.inspContentText setPlaceholderColor:[UIColor grayColor]];
    [self.inspContentText.layer setCornerRadius:2.0];
    [self.inspContentText.layer setMasksToBounds:YES];
    [self.inspContentText.layer setBorderWidth:1.0];
    [self.inspContentText.layer setBorderColor:[UIColor grayColor].CGColor];
    
    NSArray *picList = (NSArray *)[stepInfo objectForKey:@"piclst"];
    if (picList && picList.count > 0) {
        self.inspContentText.text = [NSString stringWithString:[[picList objectAtIndex:0] objectForKey:@"content"]];
    }

    CGSize rcInsp = [self.inspContentText sizeThatFits:CGSizeMake(self.inspContentText.frame.size.width, FLT_MAX)];
    self.inspContentText.py_height = rcInsp.height > 40.0f ? rcInsp.height : 40.0f;
    
    UIView *inspView = [[UIView alloc] initWithFrame:CGRectMake(0, remarkTextView.frame.origin.y + remarkTextView.frame.size.height + 30, rScreen.size.width, rcInsp.height + 80)];
    [inspView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:inspView];
    [inspView addSubview:self.inspContentText];
    
    UIView *spitLine = [[UIView alloc] initWithFrame:CGRectMake(0, rcInsp.height + 30, rScreen.size.width, 1)];
    [spitLine setBackgroundColor:[UIColor grayColor]];
    [inspView addSubview:spitLine];
    
    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, rcInsp.height + 35, 40, 20)];
    photoTitle.text = @"拍照:";
    photoTitle.font = [UIFont systemFontOfSize:13.0];
    [inspView addSubview:photoTitle];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i]]];
    }
    self.loadingImage = [UIImage animatedImageWithImages:imageArray duration:10.f];
    self.maxNum = [[stepInfo objectForKey:@"picnum"] integerValue];
    self.picViewArray = [[NSMutableArray alloc] initWithCapacity:self.maxNum];
    CGRect rcPic = CGRectMake(55, rcInsp.height + 35, 40, 40);
    for (NSInteger i = 0; i < self.maxNum; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rcPic];
        imageView.image = BACK_IMG;
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTakePhoto:)]];
        [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onPreviewPhoto:)]];
        imageView.tag = i;
        [inspView addSubview:imageView];
        rcPic.origin.x += 50;
        [self.picViewArray addObject:imageView];
    }
    
    if (picList) {
        for (NSInteger i = 0; i < picList.count; i++) {
            NSString *picUrl = (NSString *)[[picList objectAtIndex:i] objectForKey:@"picuri"];
            if ([@"" isEqualToString:picUrl]) {
                break;
            }
            else {
                if (self.picViewArray.count > i) {
                    UIImageView *imgView = (UIImageView *)[self.picViewArray objectAtIndex:i];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, picUrl]] placeholderImage:self.loadingImage];
                }
            }
        }
    }
    
    [self updateImageViewState];
    
    
    
    CGRect rcButton = CGRectMake(rScreen.size.width/2 - 50, inspView.frame.origin.y + inspView.frame.size.height + 10, 100, 30);
    self.preButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.preButton setBackgroundColor:[UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.0]];
    [self.preButton setTitle:@"上一步" forState:UIControlStateNormal];
    [self.preButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.preButton.layer setCornerRadius:2.0];
    [self.preButton.layer setMasksToBounds:YES];
    self.preButton.frame = rcButton;
    [self.preButton setHidden:YES];
    [self.preButton addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.preButton];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.0]];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton.layer setCornerRadius:2.0];
    [self.nextButton.layer setMasksToBounds:YES];
    self.nextButton.frame = rcButton;
    [self.nextButton setHidden:YES];
    [self.nextButton addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.nextButton];

    self.commitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.commitButton setBackgroundColor:[UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.0]];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton.layer setCornerRadius:2.0];
    [self.commitButton.layer setMasksToBounds:YES];
    self.commitButton.frame = rcButton;
    [self.commitButton setHidden:YES];
    [self.commitButton addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.commitButton];
    
    self.scrollView.contentSize = CGSizeMake(rScreen.size.width, self.commitButton.frame.origin.y + self.commitButton.frame.size.height);
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator setCenter:CGPointMake(rScreen.size.width/2, rScreen.size.height/2)];
    self.indicator.color = [UIColor blueColor];
    [self.view addSubview:self.indicator];
    self.userImageDict = [[NSMutableDictionary alloc] initWithCapacity:self.maxNum];
    [self setButtonState];
    [self hideTabBar];
}

- (void)updateImageViewState {
    NSInteger noPicIndex = 0;
    for (NSInteger i = 0; i < self.picViewArray.count; i++) {
        UIImageView *imageView = [self.picViewArray objectAtIndex:i];
        if (imageView.image && ![imageView.image isEqual:BACK_IMG]) {
            [imageView setHidden:NO];
            noPicIndex = i+1;
        }
        else {
            [imageView setHidden:YES];
        }
    }
    if (noPicIndex < self.picViewArray.count) {
        [[self.picViewArray objectAtIndex:noPicIndex] setHidden:NO];
    }
}

// 照相
- (IBAction)onTakePhoto:(UIGestureRecognizer *)getsture {
    if (![Utils cameraAccess]) {
        [self.view makeToast:@"请先打开相机的使用权限!" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    self.curImgViewIndex = getsture.view.tag;
    @try {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// 长按预览
- (IBAction)onPreviewPhoto:(UIGestureRecognizer *)getsture {
    if (getsture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIImageView *imgView = (UIImageView *)(getsture.view);
    self.curImgViewIndex = imgView.tag;
    UIImage *image = imgView.image;
    if (nil == image || [image isEqual:BACK_IMG]) {
        return;
    }
    
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.sourceImgageViews = @[imgView];
    [photoBroseView show];
}

- (BOOL)checkUserData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(self.step) forKey:@"step"];
    if ([self.inspContentText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入情况说明!" duration:2.0 position:CSToastPositionCenter];
        return NO;
    }
    [params setObject:self.inspContentText.text forKey:@"content"];
    NSMutableArray *picArray = [[NSMutableArray alloc] initWithCapacity:self.maxNum];
    IPubTask *pubTask = [IPubTask shareInstance];
    NSDictionary *stepInfo = [pubTask getStepInfoByStep:self.step];
    NSArray *inspedPics = (NSArray *)[stepInfo objectForKey:@"piclst"];
    for (NSInteger i = 0; i < self.maxNum; i++) {
        NSMutableDictionary *picInfo = [[NSMutableDictionary alloc]init];
        NSString *inspedImgurl = nil;
        if (inspedPics.count > i) {
            inspedImgurl = (NSString *)[[inspedPics objectAtIndex:i] objectForKey:@"picuri"];
        }
        if (inspedImgurl) {
            [picInfo setObject:inspedImgurl forKey:@"oldfile"];
        }
        else {
            [picInfo setObject:@"" forKey:@"oldfile"];
        }
        UIImage *userImg = [self.userImageDict objectForKey:@(i)];
        if (inspedImgurl == nil || [inspedImgurl isEqualToString:@""]) {
            if (nil == userImg) {
                [self.view makeToast:[NSString stringWithFormat:@"请先添加完整%ld个图片!", (long)self.maxNum] duration:2.0 position:CSToastPositionCenter];
                return NO;
            }
        }
        if (userImg) {
            [picInfo setObject:userImg forKey:@"file"];
        }
        [picArray addObject:picInfo];
    }
    [params setObject:picArray forKey:@"pics"];
    if (pubTask.inspPubArray.count >= self.step) {
        [pubTask.inspPubArray setObject:params atIndexedSubscript:self.step - 1];
    }
    else {
        [pubTask.inspPubArray addObject:params];
    }
    return YES;
}

- (void)uploadImgs {
    [[IPubTask shareInstance] generate];
    self.view.userInteractionEnabled = NO;
    [self.indicator startAnimating];
    [self uploadByIndex:0];}

- (void)uploadSuccess {
    if (![Utils locationAccess]) {
        [self.view makeToast:@"定位功能不可用!"];
        return;
    }
    NSDictionary *stepInfo = [[IPubTask shareInstance]getStepInfoByStep:self.step];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [stepInfo objectForKey:@"instcode"],
                             @"merchcode": [stepInfo objectForKey:@"merchcode"],
                             @"addrcode": [Utils getAddrCode],
                             @"shopcode": [stepInfo objectForKey:@"shopcode"],
                             @"batchcode": [stepInfo objectForKey:@"batchcode"],
                             @"serialnbr": [stepInfo objectForKey:@"serialnbr"],
                             @"data": [AFNRequestManager convertToJSONData:[IPubTask shareInstance].generateContents]
                             };
    [AFNRequestManager requestAFURL:@"inspPubTaskInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            [self.view makeToast:@"提交巡检数据成功!" duration:2.0 position:CSToastPositionCenter title:nil image:nil style:[[CSToastStyle alloc] initWithDefaultStyle]  completion:^(BOOL didTap) {
                self.view.userInteractionEnabled = YES;
                [self.indicator stopAnimating];
            }];
        }
        else {
            [self.view makeToast:@"提交巡检数据失败!" duration:2.0 position:CSToastPositionCenter];
            [self uploadFaild];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"提交巡检数据失败!" duration:2.0 position:CSToastPositionCenter];
        [self uploadFaild];
    }];
}

- (void)uploadFaild {
    [self.view makeToast:@"巡检图片上传失败,请稍后重试!" duration:2.0 position:CSToastPositionCenter];
    // 回滚图片
    NSDictionary *stepInfo = [[IPubTask shareInstance]getStepInfoByStep:self.step];
    NSDictionary *params = @{
                             @"batchcode": [stepInfo objectForKey:@"batchcode"],
                             @"serialnbr": [stepInfo objectForKey:@"serialnbr"]
                             };
    [AFNRequestManager requestAFURL:@"inspRollbackPubTaskPics.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        self.view.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
    } failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
    }];
}

- (void)uploadByIndex:(NSInteger)index {
    NSArray *inspPicArray = [IPubTask shareInstance].generatePics;
    if (inspPicArray.count <= index) {
        [self uploadSuccess];
        return;
    }
    
    NSDictionary *picInfo = [inspPicArray objectAtIndex:index];
    NSDictionary *stepInfo = [[IPubTask shareInstance] getStepInfoByStep:self.step];
    
    NSDictionary *params 	= @{
                             @"batchcode": [stepInfo objectForKey:@"batchcode"],
                             @"serialnbr": [stepInfo objectForKey:@"serialnbr"],
                             @"seq": [NSString stringWithFormat:@"%@",[picInfo objectForKey:@"step"]],
                             @"oldfile": ([picInfo objectForKey:@"file"] == nil)?[picInfo objectForKey:@"oldfile"]:@""
                             };

    index++;
    if ([picInfo objectForKey:@"file"]) {
        [AFNRequestManager requestAFURL:@"inspPubTaskPics.json" params:params imageData:UIImageJPEGRepresentation([picInfo objectForKey:@"file"], 0.2) succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadByIndex:index];
            }
            else {
                [self uploadFaild];
            }
        } failure:^(NSError *error) {
            [self uploadFaild];
        }];
    }
    else {
        [AFNRequestManager requestAFURL:@"inspPubTaskPics.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadByIndex:index];
            }
            else {
                [self uploadFaild];
            }
        } failure:^(NSError *error) {
            [self uploadFaild];
        }];
    }
}

- (IBAction)onBtnClick:(UIButton *)sender {
    if (sender == self.preButton) {
        // 上一步
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == self.nextButton) {
        // 下一步
        if ([self checkUserData]) {
            if (nil == self.nextStepViewController) {
                self.nextStepViewController = [[IPubTaskDetailViewController alloc] init];
                self.nextStepViewController.step = self.step + 1;
            }
            [self.navigationController pushViewController:self.nextStepViewController animated:YES];
        }
    }
    else if (sender == self.commitButton) {
        // 提交
        if ([self checkUserData]) {
            [self uploadImgs];
        }
    }
}


- (void)setButtonState {
    IPubTask *pubTask = [IPubTask shareInstance];
    NSInteger totalStep = pubTask.stepArray.count;
    if (totalStep == self.step) {
        if (self.step == 1) {
            [self.preButton setHidden:YES];
            [self.nextButton setHidden:YES];
            [self.commitButton setHidden:NO];
        }
        else {
            [self.preButton setHidden:NO];
            [self.nextButton setHidden:YES];
            [self.commitButton setHidden:NO];
            CGRect rcButton = self.preButton.frame;
            rcButton.origin.x -= rcButton.size.width/2 + 10;
            self.preButton.frame = rcButton;
            rcButton.origin.x += rcButton.size.width + 20;
            self.commitButton.frame = rcButton;
        }
    }
    else if (self.step == 1) {
        [self.preButton setHidden:YES];
        [self.nextButton setHidden:NO];
        [self.commitButton setHidden:YES];
    }
    else {
        [self.preButton setHidden:NO];
        [self.nextButton setHidden:NO];
        [self.commitButton setHidden:YES];
        
        CGRect rcButton = self.preButton.frame;
        rcButton.origin.x -= rcButton.size.width/2 - 10;
        self.preButton.frame = rcButton;
        rcButton.origin.x += rcButton.size.width + 20;
        self.nextButton.frame = rcButton;}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark - UIImagePickerControllerDelegate Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImageView *imgView = [self.picViewArray objectAtIndex:self.curImgViewIndex];
        [self.userImageDict setObject:image forKey:@(imgView.tag)];
        imgView.image = image;
        [self updateImageViewState];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
