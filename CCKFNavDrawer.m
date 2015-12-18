//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.


#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "CustomCellForSlider.h"
#import "AppDelegate.h"
#import "ConfigTaskForYou.h"
#import "DataClass.h"
#import "HomeScreenView.h"



#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350
#define ISIPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface CCKFNavDrawer (){
    
    DataClass *dClassObject;
    
}
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuItemsImages;

@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;

@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;
@property(nonatomic,assign) int DoCheck;
@end

@implementation CCKFNavDrawer
@synthesize DoCheck,menuItems;



@synthesize menuItemsImages;
#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dClassObject =[DataClass getInstance];
    
	// Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoad! called in CCKFNavDrawer");
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        if (ISIPHONE_5) { // Iphone 5 and 5+....
            
           // [ setCornerRadius:37];
            
            
        }else if (ISIPHONE_6){ // Iphone 6 or 6+...
            
           // [imgLayer setCornerRadius:58];
            
        }else{
            
            // Ipad.....
        }
    }

    [self setUpDrawer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer
{
    
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    self.meunHeight = self.drawerView.frame.size.height;
    self.menuWidth = self.drawerView.frame.size.width;
    
    
    
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];

    // drawer list
   // [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    
     [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    
    
    // 15 may changed to prevent root view control presentation......;/
    
    self.pan_gr.maximumNumberOfTouches = 0;     //1;
    self.pan_gr.minimumNumberOfTouches = 0 ;      // 1;
    
    // 15 may changed to prevent root view control presentation......;/

    
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

- (void)drawerToggle:(int)myCheck
{

    [self.drawerView.drawerTableView reloadData];
    DoCheck=myCheck;
    NSLog(@"---mycheck is ====%i",DoCheck);
    NSLog(@"drawerToggle called!");
    
    if (DoCheck==1) {
        
        self.menuItems=@[@" ",@"To do",@"Assigned",@"Completed",@"Overdue",@"Settings",@"Personal Priority",];
        
        self.menuItemsImages=@[@"menu_payment_icon.png",@"current_order_icon.png",@"menu_payment_icon.png",@"menu_settings_icon.png",@"menu_contactus_icon.png",@"menu_logout_icon.png",@"abc.png"];
    }
    else{
        
      //  self.menuItems = @[@"Admin Report", @"Add Organization", @"Question", @"Mail Content", @"Change Password",@"Email",@"Edit Organization",@"Sub Admin",@"Log Out"];
    }
    
    
    if (!self.isOpen) {
        
        [self openNavigationDrawer];
        
    }else{
        
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer{
    
    
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*fabs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    

    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
    
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    [self.drawerView.drawerTableView reloadData];
    
}


- (void)closeNavigationDrawer{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveIcon" object:self];
    
//    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*fabs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self closeNavigationDrawer];
}



- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    
    [self closeNavigationDrawer];
    
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
//        NSLog(@"end");
        if (self.drawerView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (DoCheck==1) {
        //return 3;   // for provider ...
        
        return menuItems.count;;
        
    }
    else{
        
       // return menuItems.count;
    }

    return menuItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DoCheck==1) {
        static NSString *kCellID = @"Cell";
        CustomCellForSlider *cell = (CustomCellForSlider *)[tableView dequeueReusableCellWithIdentifier:kCellID];
        
        if (cell == nil)
        {
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                
                    NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"CustomeCellForSlider_5" owner:self options:nil ];
                    cell =  [cellArray objectAtIndex:0];
                    
            }
            
            
            NSUInteger lastObject=[menuItems count]-1;
            
            NSLog(@"last object no---%lu",(unsigned long)lastObject);
            
            NSLog(@"last object no indexPath---%lu",(unsigned long)indexPath.row);


            cell.lbl_cellItemName.text=[menuItems objectAtIndex:indexPath.row];
            
            
            if (indexPath.row==0) {
                
          
               CALayer *imgLayer = [cell.img_SliderProfile layer];
               [imgLayer setMasksToBounds:YES];
               
               if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                   
                   
                      // [imgLayer setCornerRadius:37];
                       
                       }
                
                
                UIImage *image_Achieved =  [[UIImage alloc] initWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"ProfileImageData"]];
                cell.img_SliderProfile.contentMode = UIViewContentModeScaleAspectFill;
                cell.img_SliderProfile.image = image_Achieved ;
                
                [cell.lbl_blueColorForTap setHidden:NO];
              //  cell.img_SliderProfile.image = dClassObject.img_SliderImage;//[[NSUserDefaults standardUserDefaults]valueForKey:@"ImageName"];

                [cell.img_InnerImage setHidden:NO];
                [cell.img_SliderProfile setHidden:NO];
        
                cell.lbl_SliderUserName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"firstName"];
                NSLog(@"nsuser default name ---%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"firstName"]);

                [cell.img_Icon setHidden:YES];
                
                [cell.imgClose setImage:[UIImage imageNamed:@"1.png"]];
                [cell.lbl_saperaterLineAfterPaymentDarkGray setHidden:YES];
                [cell.lbl_saperaterLineAfterPaymentLightGray setHidden:YES];
                [cell.btn_switchOutlet setHidden:YES];
                
                
            }
            
            else{
                
                [cell.imgClose setHidden:YES];
                [cell.lbl_blueColorForTap setHidden:YES];
                [cell.lblEmail setHidden:YES];
                [cell.img_Icon setHidden:NO];
                [cell.lbl_saperaterLineAfterLightUserName setHidden:YES];
                [cell.lbl_saperaterLineAfterUserName setHidden:YES];

                [cell.lbl_SliderUserName setHidden:YES];
                [cell.img_InnerImage setHidden:YES];
                [cell.img_SliderProfile setHidden:YES];
                cell.img_Icon.image=[UIImage imageNamed:[self.menuItemsImages objectAtIndex:indexPath.row]];
                [cell.btn_switchOutlet setHidden:YES];
            }
            
            
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){

//                if (ISIPHONE_5) {
//                    
//                    
//                    
//                    // iphone 5 normal...
//                    
//                }
//                else{
                
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
             //   }
            }
            
        }
        
        return cell;

    }
    return 0;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  //  cell.contentView.backgroundColor=[UIColor colorWithRed:54/255.0f green:168/255.0f blue:216/255.0f alpha:1.0];
  //  cell.contentView.backgroundColor=[UIColor clearColor];
    
    
    [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
    [self closeNavigationDrawer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        
            if (indexPath.row==0) {
                
                return 150;
                
            }else{
                
                return 50;
            }

    }
    return 0;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 32.0f;
    
}

/*
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row==0) {
        
        cell.backgroundColor=[UIColor greenColor];
    }
    else{
        cell.backgroundColor=[UIColor redColor];
        cell.contentView.backgroundColor=[UIColor redColor];
    }
    
    return YES;
}

 */
 
@end
