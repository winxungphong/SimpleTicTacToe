//
//  ViewController.m
//  SimpleTicTacToe
//
//  Created by MinhHT on 7/27/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "ViewController.h"

#define YELLOW_NOTE 1
#define RED_NOTE    2
#define NUMBER_OF_NOTES 100

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwBase;
@property (assign, nonatomic) NSInteger numOfTurns;
@property (weak, nonatomic) IBOutlet UILabel *lblScore1;
@property (weak, nonatomic) IBOutlet UILabel *lblScore2;
@property (strong, nonatomic) NSMutableArray *myButtonArr;
@property (strong, nonatomic) NSMutableArray *myButtonTags;
@property (assign, nonatomic) NSInteger player1Score;
@property (assign, nonatomic) NSInteger player2Score;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetNumberOfPlay];
    
    [self.vwBase setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern_bg"]]];
    
    self.myButtonArr = [NSMutableArray new];
    self.myButtonTags = [NSMutableArray new];
    //List tag of buttons
    for (int i = 0; i < 14*14; i++) {
        [self.myButtonTags addObject:[NSNumber numberWithInt:0]];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    for (NSInteger i = 0; i < 10; i++) {
        for (NSInteger j = 0 ; j < 10 ; j++) {
            UIView *viewBlock = [[UIView alloc] initWithFrame:CGRectMake(10+i*30, 10+j*30, 30, 30)];
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                button.tag = i*14 + j + 30;
                [button addTarget:self action:@selector(touchToPlay:) forControlEvents:UIControlEventTouchUpInside];
                [viewBlock addSubview:button];
            [self.myButtonArr addObject:button];
            [viewBlock setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"square_white"]]];
            [self.vwBase addSubview:viewBlock];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchToPlay:(UIButton*)sender {
    NSLog(@"view tag %ld \n",sender.tag);
       //make button cannot be touch anymore
    [sender setUserInteractionEnabled:NO];
    [self addTurnOfPlays];
    switch (self.numOfTurns%2) {
        case 0: {
            [sender setBackgroundImage:[UIImage imageNamed:@"o_square"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.myButtonTags replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:RED_NOTE]];
            [self checkWinnerForLastestTurn:sender.tag andLastValue:RED_NOTE];

        }
            break;
        case 1: {
            [sender setBackgroundImage:[UIImage imageNamed:@"x_square"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.myButtonTags replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:YELLOW_NOTE]];
            [self checkWinnerForLastestTurn:sender.tag andLastValue:YELLOW_NOTE];
        }
            
            break;
        default:
            break;
    }
    NSLog(@"array of Button tags == %@ \n",self.myButtonTags);
    
}

- (void)addTurnOfPlays {
    self.numOfTurns++;
}

- (IBAction)resetScore:(id)sender {
    [self resetNumberOfPlay];
    [self resetScoreOfPlayers];
}

- (IBAction)restartMatch:(id)sender {
    [self resetNumberOfPlay];
    
}

- (void)resetScoreOfPlayers {
    self.player1Score = 0;
    self.player2Score = 0;
    self.lblScore1.text = [NSString stringWithFormat:@"%d",self.player1Score];
    self.lblScore2.text = [NSString stringWithFormat:@"%d",self.player2Score];
}

- (void)resetNumberOfPlay {
    self.numOfTurns = 0;
//    for (id subview in self.vwBase.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            [subview setTitle:@"" forState:UIControlStateNormal];
//        }
//    }
    for (id item in self.myButtonArr) {
        if ([item isKindOfClass:[UIButton class]]) {
            [item setBackgroundImage:nil forState:UIControlStateNormal];
            [item setUserInteractionEnabled:YES];
        }
    }
    //Reset all Number of Button tags to value 0
    for (int i = 0; i < 14*14; i++) {
        [self.myButtonTags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];    }
}


- (void)checkWinnerForLastestTurn:(NSInteger)lastestSquareTag andLastValue:(NSInteger)value{
    //Check the rows
    if (([[self.myButtonTags objectAtIndex:lastestSquareTag-14] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+14] integerValue] == value)
        
       )
          {
              [self showTheWinner:value];
    }
    
    if (([[self.myButtonTags objectAtIndex:lastestSquareTag-14] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag-28] integerValue] == value)
        
        )
    {
        [self showTheWinner:value];
    }
    
    if (([[self.myButtonTags objectAtIndex:lastestSquareTag+14] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+28] integerValue] == value)
        
        )
    {
        [self showTheWinner:value];
    }
    
    //Check the column
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-1] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag-2] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-1] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+1] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag+1] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+2] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    //Check the diagonal
    /*  X
     *   X
     *    X
    */
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-15] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag-30] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-15] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+15] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag+15] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+30] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    //Check the diagonal
    /*    X
     *   X
     *  X
     */
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-13] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag-26] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag-13] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+13] integerValue] == value))
    {
        [self showTheWinner:value];
    }
    
    
    if ( ([[self.myButtonTags objectAtIndex:lastestSquareTag+13] integerValue] == value)
        && ([[self.myButtonTags objectAtIndex:lastestSquareTag+26] integerValue] == value))
    {
        [self showTheWinner:value];
    }
}

- (void)showTheWinner:(NSInteger)valueColorOfWinner {
    [self updateScoreForPlayer:valueColorOfWinner];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MATCH END" message:(valueColorOfWinner == RED_NOTE) ? @"Player 2 Win!" : @"Player 1 Win!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
  
    
//    if (valueColorOfWinner == YELLOW_NOTE) {
//        self.lblPlayer1.text = [NSString stringWithFormat:""];
//    }

}

- (void)updateScoreForPlayer:(NSInteger)valueColorOfWinner {
    if (valueColorOfWinner == YELLOW_NOTE) {
        self.player1Score++;
        self.lblScore1.text = [NSString stringWithFormat:@"%d",self.player1Score];
    } else if (valueColorOfWinner == RED_NOTE) {
        self.player2Score++;
        self.lblScore2.text = [NSString stringWithFormat:@"%d",self.player2Score];
    }
}




#pragma mark - Alertview 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self restartMatch:nil];
}


@end
