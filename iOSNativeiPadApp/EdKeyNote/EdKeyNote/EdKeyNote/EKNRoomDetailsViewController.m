//
//  EKNRoomDetailsViewController.m
//  EdKeyNote
//
//  Created by Max on 10/9/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNRoomDetailsViewController.h"

@interface EKNRoomDetailsViewController ()

@end

@implementation EKNRoomDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIButton *showIncidentCommentPopupBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 120, 250, 40)];
    [showIncidentCommentPopupBtn setTitle:@"Show Incident Comment" forState:UIControlStateNormal];
    [showIncidentCommentPopupBtn setBackgroundColor:[UIColor redColor]];
    [showIncidentCommentPopupBtn addTarget:self action:@selector(showIncidentCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showIncidentCommentPopupBtn];
    
    UIButton *showCommentPopupBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 220, 250, 40)];
    [showCommentPopupBtn setTitle:@"Show Comment" forState:UIControlStateNormal];
    [showCommentPopupBtn setBackgroundColor:[UIColor redColor]];
    [showCommentPopupBtn addTarget:self action:@selector(showCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showCommentPopupBtn];
    
    [self initIncidentCommentPopupView];
    [self initCommentPopupView];
}

-(void) showIncidentCommentAction
{
    self.commentPopupView.hidden = YES;
    self.incidentCommentPopupView.hidden = NO;
}

-(void) showCommentAction
{
    self.incidentCommentPopupView.hidden = YES;
    self.commentPopupView.hidden = NO;
}

-(void) hideIncidentCommentAction
{
    self.incidentCommentPopupView.hidden = YES;
}

-(void) hideCommentAction
{
    self.commentPopupView.hidden = YES;
}

-(void) takeCommentCameraAction
{
    self.isIncidentCommentCamera = NO;
    [self takePhoto];
}

-(void) takeIncidentCommentCameraAction
{
    self.isIncidentCommentCamera = YES;
    [self takePhoto];
}

- (void)takePhoto
{
    UIActionSheet *sheet;
    if(self.cameraIsAvailable)
    {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"New Photo", @"Select Photo", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Select Photo", nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && self.cameraIsAvailable)//take new photo
    {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self openCamera];
        }];
    }else if(buttonIndex == 1)//select photo library
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self selectPicture];
        }];
        
    }
}

- (void)openCamera
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

-(void)selectPicture
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        //NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support that media source."
                              delegate:nil
                              cancelButtonTitle:@"Drat"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //UIImage *shrunkenImage = [self shrinkImage:chosenImage toSize:chosenImage.size];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 340, 40 , 40)];
    imgview.image = chosenImage;
    [self.view addSubview:imgview];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initIncidentCommentPopupView
{
    self.incidentCommentPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 389)];
    self.incidentCommentPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.35];;
    
    self.incidentCommentCamera = [[UIButton alloc] initWithFrame:CGRectMake(32, 30, 64, 52)];
    [self.incidentCommentCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.incidentCommentCamera addTarget:self action:@selector(takeIncidentCommentCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.incidentCommentPopupView addSubview:self.incidentCommentCamera];
    
    UIView *imgBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 30, 886, 99)];
    imgBackgoundView.backgroundColor = [UIColor whiteColor];
    imgBackgoundView.layer.masksToBounds = YES;
    imgBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:imgBackgoundView];
    
    UIImageView *roomImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(141, 40, 105, 79)];
    roomImageView1.image = [UIImage imageNamed:@"demo_room"];
    [self.incidentCommentPopupView addSubview:roomImageView1];
    
    UIImageView *roomImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(281, 40, 105, 79)];
    roomImageView2.image = [UIImage imageNamed:@"demo_room"];
    [self.incidentCommentPopupView addSubview:roomImageView2];
    
    UIImageView *roomImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(421, 40, 105, 79)];
    roomImageView3.image = [UIImage imageNamed:@"demo_room"];
    [self.incidentCommentPopupView addSubview:roomImageView3];
    
    UIImageView *roomImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(561, 40, 105, 79)];
    roomImageView4.image = [UIImage imageNamed:@"demo_room"];
    [self.incidentCommentPopupView addSubview:roomImageView4];
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(32, 149, 960, 160)];
    commentBackgoundView.backgroundColor = [UIColor whiteColor];
    commentBackgoundView.layer.masksToBounds = YES;
    commentBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:commentBackgoundView];
    
    UITextField *incidentCommentTxt = [[UITextField alloc] initWithFrame:CGRectMake(52, 169, 920, 120)];
    [self.incidentCommentPopupView addSubview:incidentCommentTxt];
    
    UIView *iincidentTypeBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(32, 329, 376, 32)];
    iincidentTypeBackgoundView.backgroundColor = [UIColor whiteColor];
    iincidentTypeBackgoundView.layer.masksToBounds = YES;
    iincidentTypeBackgoundView.layer.cornerRadius = 5;
    [self.incidentCommentPopupView addSubview:iincidentTypeBackgoundView];
    
    UILabel *incidentTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(47, 329, 361, 32)];
    incidentTypeLbl.textColor = [UIColor blackColor];
    incidentTypeLbl.text = @"Incident Type";
    incidentTypeLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.incidentCommentPopupView addSubview:incidentTypeLbl];
    
    UIImageView *dropdownImg = [[UIImageView alloc] initWithFrame:CGRectMake(378, 338, 17, 14)];
    dropdownImg.image = [UIImage imageNamed:@"dropdown_arrow"];
    [self.incidentCommentPopupView addSubview:dropdownImg];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(880, 319, 112, 50)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    done.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    done.titleLabel.textColor = [UIColor whiteColor];
    done.layer.masksToBounds = YES;
    done.layer.cornerRadius = 5;
    [done addTarget:self action:@selector(hideIncidentCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.incidentCommentPopupView addSubview:done];
    
    self.incidentCommentPopupView.hidden = YES;
    [self.view addSubview:self.incidentCommentPopupView];
}

- (void) initCommentPopupView
{
    self.commentPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 389)];
    self.commentPopupView.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(0.00/255.00f) blue:(0.00/255.00f) alpha:0.35];;
    
    self.commentCamera = [[UIButton alloc] initWithFrame:CGRectMake(32, 30, 64, 52)];
    [self.commentCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.commentCamera addTarget:self action:@selector(takeCommentCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentPopupView addSubview:self.commentCamera];
    
    UIView *imgBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 30, 886, 99)];
    imgBackgoundView.backgroundColor = [UIColor whiteColor];
    imgBackgoundView.layer.masksToBounds = YES;
    imgBackgoundView.layer.cornerRadius = 5;
    [self.commentPopupView addSubview:imgBackgoundView];
    
    UIImageView *roomImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(141, 40, 105, 79)];
    roomImageView1.image = [UIImage imageNamed:@"demo_room"];
    [self.commentPopupView addSubview:roomImageView1];
    
    UIImageView *roomImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(281, 40, 105, 79)];
    roomImageView2.image = [UIImage imageNamed:@"demo_room"];
    [self.commentPopupView addSubview:roomImageView2];
    
    UIImageView *roomImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(421, 40, 105, 79)];
    roomImageView3.image = [UIImage imageNamed:@"demo_room"];
    [self.commentPopupView addSubview:roomImageView3];
    
    UIImageView *roomImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(561, 40, 105, 79)];
    roomImageView4.image = [UIImage imageNamed:@"demo_room"];
    [self.commentPopupView addSubview:roomImageView4];
    
    UIView *commentBackgoundView = [[UIView alloc] initWithFrame:CGRectMake(106, 149, 886, 160)];
    commentBackgoundView.backgroundColor = [UIColor whiteColor];
    commentBackgoundView.layer.masksToBounds = YES;
    commentBackgoundView.layer.cornerRadius = 5;
    [self.commentPopupView addSubview:commentBackgoundView];
    
    UITextField *commentTxt = [[UITextField alloc] initWithFrame:CGRectMake(121, 169, 920, 120)];
    [self.commentPopupView addSubview:commentTxt];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(880, 319, 112, 50)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:(100.00/255.00f) green:(153.00/255.00f) blue:(209.00/255.00f) alpha:1.0];
    done.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    done.titleLabel.textColor = [UIColor whiteColor];
    done.layer.masksToBounds = YES;
    done.layer.cornerRadius = 5;
    [done addTarget:self action:@selector(hideCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentPopupView addSubview:done];
    
    self.commentPopupView.hidden = YES;
    [self.view addSubview:self.commentPopupView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
