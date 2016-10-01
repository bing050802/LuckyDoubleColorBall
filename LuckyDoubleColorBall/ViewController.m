//
//  ViewController.m
//  LuckyDoubleColorBall
//
//  Created by lyfscb on 16/10/1.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "ViewController.h"
#import "ComboArray.h"
@interface ViewController ()
@property (nonatomic,strong)NSMutableArray *blueBallButtons;
@property (nonatomic,strong)NSMutableArray *redBallButtons;
@property (nonatomic,strong)NSMutableArray *selectedBlueBalls;
@property (nonatomic,strong)NSMutableArray *selectedRedBalls;

@property (nonatomic)IBOutlet NSTextField *list;
@property (nonatomic)IBOutlet NSComboBox *redBox;
@property (nonatomic)IBOutlet NSComboBox *blueBox;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _blueBallButtons = [[NSMutableArray alloc]initWithCapacity:16];
    _redBallButtons  = [[NSMutableArray alloc]initWithCapacity:33];
    _selectedRedBalls= [[NSMutableArray alloc]init];
    _selectedBlueBalls= [[NSMutableArray alloc]init];
    
    for (NSView *view in [self.view subviews]) {
        if (view.tag >=1 && view.tag <=33) {
            [_redBallButtons addObject:view];
            NSButton *btn = (NSButton*)view;
            btn.action = @selector(redBallPressed:);
        }
        if (view.tag >= 34 && view.tag <= 49) {
            [_blueBallButtons addObject:view];
            NSButton *btn = (NSButton*)view;
            btn.action = @selector(blueBallPressed:);
        }
    }
    
    [_redBox selectItemAtIndex:0];
    [_blueBox selectItemAtIndex:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comboBoxSelectionDidChange:) name:NSComboBoxSelectionDidChangeNotification object:nil];

//    [_blueBallButtons makeObjectsPerformSelector:@selector(setAction:) withObject:@selector(blueBallPressed:)];
    
//    NSLog(@"%@ %@",_redBallButtons,_blueBallButtons);

    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(IBAction)blueBallPressed:(id)sender{
    NSInteger tag = [sender tag];
    NSNumber *object = @(tag-33);
    if ([_selectedBlueBalls indexOfObject:object] != NSNotFound) {
        [_selectedBlueBalls removeObject:object];
//        [sender setImage:[NSImage imageNamed:@"MacQQ_point_single_gray"]];
    }else{
//        [sender setImage:[NSImage imageNamed:@"close_button"]];
        [_selectedBlueBalls addObject:object];
    }
    
    [self loadBlueBallsState];
}
-(IBAction)redBallPressed:(id)sender{
    NSInteger tag = [sender tag];
    NSNumber *num = @(tag);
    if ([_selectedRedBalls indexOfObject:num] != NSNotFound) {
        [_selectedRedBalls removeObject:num];
//        [sender setImage:[NSImage imageNamed:@"MacQQ_point_single_gray"]];
    }else{
//        [sender setImage:[NSImage imageNamed:@"MacQQ_point_single"]];
        [_selectedRedBalls addObject:num];
    }
    NSLog(@"%@",_selectedRedBalls);
    [self loadRedBallsState];
}
-(void)loadRedBallsState{
    
    for (NSButton *view in _redBallButtons){
      [view setImage:[NSImage imageNamed:@"MacQQ_point_single_gray"]];
    }
    for (NSNumber *num in _selectedRedBalls) {
        for (NSButton *view in _redBallButtons) {
            if (view.tag == [num integerValue]) {
                [view setImage:[NSImage imageNamed:@"MacQQ_point_single"]];
                break;
            }
        }
     
    }
  
}

-(void)loadBlueBallsState{
    for (NSButton *view in _blueBallButtons){
        [view setImage:[ NSImage imageNamed:@"MacQQ_point_single_gray"]];
    }

    for (NSNumber *num in _selectedBlueBalls) {
        for (NSButton *view in _blueBallButtons) {
            
            if (view.tag == [num integerValue]+33) {
                [view setImage:[NSImage imageNamed:@"close_button"]];
                break;
            }
        }
     
    }

}

-(IBAction)clearSelectedBalls:(id)sender{
    NSInteger tag = [sender tag];
    if (tag == 54) {
        [_selectedRedBalls removeAllObjects];
        [self loadRedBallsState];
    }
    if (tag == 55) {
        [_selectedBlueBalls removeAllObjects];
        [self loadBlueBallsState];
    }
}

-(IBAction)randonSelectingBolls:(id)sender{
    
    NSInteger tag = [sender tag];
    [self randonSelecting:tag];
    return;
    
    if (tag == 52) {
        [_selectedRedBalls removeAllObjects];
        [_selectedRedBalls addObjectsFromArray:[self randonSelectCount:_redBox.indexOfSelectedItem+6 max:33]];
        [self loadRedBallsState];
    }
    
    if (tag == 53) {
        [_selectedBlueBalls removeAllObjects];
        [_selectedBlueBalls addObjectsFromArray:[self randonSelectCount:_blueBox.indexOfSelectedItem+1 max:16]];
        [self loadBlueBallsState];
    }

}

-(void)randonSelecting:(NSInteger)tag{
    
    if (tag == 52 || tag == 50) {
        [_selectedRedBalls removeAllObjects];
        [_selectedRedBalls addObjectsFromArray:[self randonSelectCount:_redBox.indexOfSelectedItem+6 max:33]];
        [self loadRedBallsState];
    }
    
    if (tag == 53 || tag == 51) {
        [_selectedBlueBalls removeAllObjects];
        [_selectedBlueBalls addObjectsFromArray:[self randonSelectCount:_blueBox.indexOfSelectedItem+1 max:16]];
        [self loadBlueBallsState];
    }
}

-(IBAction)doubleBallsList:(id)sender{
    
    
    
//    NSLog(@"%@",[ComboArray comboArray:_selectedRedBalls m:6]);
    NSArray *redBalls = [ComboArray comboArray:_selectedRedBalls m:6];
    for (NSArray *array in redBalls) {
        NSString *str = [array componentsJoinedByString:@","];
        NSLog(@"%@",str);
    }
    
    NSArray *blueBalls = [ComboArray comboArray:_selectedBlueBalls m:1];
    for (NSArray *array in blueBalls) {
        NSString *str = [array componentsJoinedByString:@","];
        NSLog(@"%@",str);
    }
    
    NSMutableString *str = [[NSMutableString alloc]init];
    
    for (NSInteger i=0; i< redBalls.count; i++) {
                 NSArray *rarray = redBalls[i];
        for (NSInteger j=0; j< blueBalls.count; j++) {
            NSArray *barray =blueBalls[j];
            NSLog(@"红球%@,蓝球%@",[rarray componentsJoinedByString:@","],[barray firstObject]);
            [str appendFormat:@":红球%@,蓝球:%@\n",[rarray componentsJoinedByString:@","],[barray firstObject] ];
        }
    }
    [_list setStringValue:str];
    
 
    
    
}
-(NSArray *)randonSelectCount:(NSInteger)count max:(NSInteger)max{
    NSMutableArray *randonNum = [[NSMutableArray alloc]initWithCapacity:max];
    for (NSInteger i = 1; i <= max; i++) {
        [randonNum addObject:@(i)];
    }
    
    NSMutableArray *select = [[NSMutableArray alloc]init];
    

    
    for (int i = 0; i< count; i++) {
        int index = arc4random_uniform((int)randonNum.count);
        NSLog(@"%@ %d",randonNum,index);
        id object = randonNum[index];
        if ([select indexOfObject:object] == NSNotFound) {
            [select addObject:object];
        }else{
            i--;
        }
    }
    
    return select;

}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSLog(@"%@",notification);
    NSComboBox *box = [notification object];
    [self randonSelecting:box.tag];

}


@end
