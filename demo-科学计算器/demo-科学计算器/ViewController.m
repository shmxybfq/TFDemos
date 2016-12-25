//
//  ViewController.m
//  demo-科学计算器
//
//  Created by 融数 on 16/12/19.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,  copy)NSString *suanshi;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

@implementation ViewController
- (IBAction)buttonAction:(id)sender {
    
    
    long double result = [self base3ResultWithFormulaString:self.suanshi];
    self.textField2.text = [NSString stringWithFormat:@"%Lf",result];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.suanshi =@"1+2*((2+3.14*4+5)/2*3-2)+3*6";
    self.textField1.text = self.suanshi;
//    self.suanshi =@"1.55+2-3.1415926*(5-6*7.5/8)*2+1";
//    self.suanshi =@"1.5+2-3.5*5-6*7.5/8*2+1";
//    self.suanshi =@"1+0.5/3*2+((2-12)*(2+1)-(3*5))";//43.66
//    self.suanshi =@"100+10+9*3/2+1*(9-8)+3";//127.5
  
}


//去除括号
-(long double)base3ResultWithFormulaString:(NSString *)formula_S
{
    long double ts = 0.0;
    
    
    NSString *tem_formula_S =@"";
    
    NSRange bracket_left = [formula_S rangeOfString:@"("];
    NSRange bracket_right = [formula_S rangeOfString:@")"];
    
    while (bracket_left.location!=NSNotFound && bracket_right.location!=NSNotFound) {
        tem_formula_S = @"";
        
        NSInteger index_bracket_left = bracket_left.location;
        NSInteger index_bracket_right = bracket_right.location;
        
        for (int i =0; i<formula_S.length; i++) {
            NSString *tem_C2 =[formula_S substringWithRange:NSMakeRange(i, 1)];
            if ([tem_C2 isEqualToString:@"("]) {
                index_bracket_left = i;
            }
            if ([tem_C2 isEqualToString:@")"]) {
                index_bracket_right =i;
                break;
            }
        }
        if (index_bracket_left !=0) {
            tem_formula_S  =[tem_formula_S stringByAppendingString:[formula_S substringToIndex:index_bracket_left]];
        }
        NSString *bracket_content = [formula_S substringWithRange:NSMakeRange(index_bracket_left +1, index_bracket_right - index_bracket_left -1)];
        
        ts = [self base2ResultWithFormulaString:bracket_content];
        NSString *tem_ts =[self removeZeroNumberWithString:[NSString stringWithFormat:@"%Lf",ts]];
        tem_formula_S  =[tem_formula_S stringByAppendingString:tem_ts];
        if (index_bracket_right !=formula_S.length -1) {
            tem_formula_S  =[tem_formula_S stringByAppendingString:[formula_S substringFromIndex:index_bracket_right +1]];
        }
        
        formula_S =tem_formula_S;
        tem_formula_S =@"";
        bracket_left = [formula_S rangeOfString:@"("];
        bracket_right = [formula_S rangeOfString:@")"];
    }
    
    ts = [self base2ResultWithFormulaString:formula_S];
    return ts;
}




//去除乘除号
-(long double)base2ResultWithFormulaString:(NSString *)formula_S
{
    long double ts = 0.0;
    
    NSMutableArray *formula_A =[NSMutableArray arrayWithArray:[self stringChangeToArrayWithFormulaString:formula_S]];
    
    NSMutableArray *tem_formula_A =[NSMutableArray array];
    
    BOOL has_ride = [formula_A containsObject:@"*"];
    BOOL has_divide = [formula_A containsObject:@"/"];
    
    while (has_ride || has_divide) {
        [tem_formula_A removeAllObjects];
        
        NSString *calculate_type = @"";
        NSInteger index_symbol   = 0;
        
        NSInteger index_ride = [formula_A indexOfObject:@"*"];
        NSInteger index_divide = [formula_A indexOfObject:@"/"];
        
        if (index_ride != NSNotFound && index_divide!=NSNotFound) {
            if (index_ride < index_divide) {
                calculate_type = @"*";
                index_symbol =index_ride;
            }else{
                calculate_type = @"/";
                index_symbol =index_divide;
            }
        }else if(index_ride == NSNotFound && index_divide!=NSNotFound){
            calculate_type = @"/";
            index_symbol =index_divide;
        }else if(index_ride != NSNotFound && index_divide==NSNotFound){
            calculate_type = @"*";
            index_symbol =index_ride;
        }
        
        
        [tem_formula_A addObjectsFromArray:[formula_A subarrayWithRange:NSMakeRange(0, index_symbol -1)]];
        if (index_symbol -1 >= 0 && index_symbol+1 <= formula_A.count -1) {
            
            NSString *numPre = [formula_A objectAtIndex:index_symbol -1];
            NSString *numSuf = [formula_A objectAtIndex:index_symbol +1];
            
            NSString *tem_formula_S = [NSString stringWithFormat:@"%@%@%@",numPre,calculate_type,numSuf];
            long double tem_ts =[self base1ResultWithFormulaString:tem_formula_S];
            NSString *tem_ts_S =[NSString stringWithFormat:@"%Lf",tem_ts];
            
            [tem_formula_A addObject:tem_ts_S];
            [tem_formula_A addObjectsFromArray:[formula_A subarrayWithRange:NSMakeRange(index_symbol +2, formula_A.count - (index_symbol +2))]];
            [formula_A removeAllObjects];
            [formula_A addObjectsFromArray:tem_formula_A];
            [tem_formula_A removeAllObjects];
            
            has_ride = [formula_A containsObject:@"*"];
            has_divide = [formula_A containsObject:@"/"];
            
            NSLog(@"-------tem_ts_S-------%@",tem_ts_S);
            NSLog(@"-------formula_A-------%@",formula_A);
            NSLog(@"-------===========================-------");
        }
    }
    
    //计算减去乘除候的最后结果
    NSString *formula_last_S =@"";
    for (int i =0; i< formula_A.count; i++) {
        NSString *tem_C = [formula_A objectAtIndex:i];
        formula_last_S =[formula_last_S stringByAppendingString:[self removeZeroNumberWithString:tem_C]];
    }
    ts =[self base1ResultWithFormulaString:formula_last_S];
    
    return ts;
}

//去掉后面的零
-(NSString *)removeZeroNumberWithString:(NSString *)str
{
    NSRange point_r = [str rangeOfString:@"."];
    NSLog(@"==========减肥前=====%@",str);
    if (point_r.location != NSNotFound) {
        for (int i =str.length-1; i>=0; i--) {
            NSString *zeros =@"0";
            for (int j =0; j<=i; j++) {
                zeros = [zeros stringByAppendingString:@"0"];
            }
            if ([str hasSuffix:zeros]) {
                str = [str stringByReplacingOccurrencesOfString:zeros withString:@"0"];
                break;
            }
        }
    }
    NSLog(@"==========减肥后=====%@",str);
    return str;
}


-(long double)base1ResultWithFormulaString:(NSString *)formula_S
{
    long double ts = 0.0;
    
    NSMutableArray *formula_A =[self stringChangeToArrayWithFormulaString:formula_S];
    NSArray *symbol_A  = @[@"+",@"-",@"*",@"/"];
    NSString *symbol_C = @"";
    
    for (int i =0; i< formula_A.count; i++) {
        NSString *tem_C =[formula_A objectAtIndex:i];
        if ([symbol_A containsObject:tem_C]) {
            symbol_C = tem_C;
        }else{
            if (ts == 0.0) {
                ts =[tem_C doubleValue];
            }
        }
        if (![symbol_A containsObject:tem_C]) {
            if ([symbol_C isEqualToString:@"+"]) {
                ts += [tem_C doubleValue];
            }
            if ([symbol_C isEqualToString:@"-"]) {
                ts -= [tem_C doubleValue];
            }
            if ([symbol_C isEqualToString:@"*"]) {
                ts *= [tem_C doubleValue];
            }
            if ([symbol_C isEqualToString:@"/"]) {
                ts /= [tem_C doubleValue];
            }
        }
        
    }
    NSLog(@"----------ts-----------%Lf",ts);
    return ts;
}

//字符串算式 转换成数组
-(NSMutableArray *)stringChangeToArrayWithFormulaString:(NSString *)formula_S
{
    NSLog(@"------------formula_S-----------------%@",formula_S);
    NSArray *symbol_A=@[@"+",@"-",@"*",@"/",@"(",@")"];
    NSArray *number_A=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"."];
    
    NSMutableArray *formula_A=[NSMutableArray array];
    NSString *tem_S=@"";
    
    for (int i=0; i<formula_S.length; i++) {
        
        NSRange tem_R=NSMakeRange(i, 1);
        NSString *tem_C=[formula_S substringWithRange:tem_R];
        
        if ([number_A containsObject:tem_C]) {
            tem_S =[tem_S stringByAppendingString:tem_C];
            if (i == formula_S.length -1) {
                [formula_A addObject:[tem_S copy]];
                tem_S =@"";
            }
        }else{
            if ([symbol_A containsObject:tem_C]) {
                
                if ([tem_C isEqualToString:@"-"]||[tem_C isEqualToString:@"+"]) {
                    if (i==0) {
                        tem_S =[tem_S stringByAppendingString:tem_C];
                    }else{
                        
                        NSRange tem_R2=NSMakeRange(i -1, 1);
                        NSString *tem_C2=[formula_S substringWithRange:tem_R2];
                        if ([tem_C2 isEqualToString:@"+"]||[tem_C2 isEqualToString:@"-"]||[tem_C2 isEqualToString:@"*"]||[tem_C2 isEqualToString:@"/"]) {
                            tem_S =[tem_S stringByAppendingString:tem_C];
                        }else{
                            [formula_A addObject:[tem_S copy]];
                            tem_S =@"";
                            [formula_A addObject:[tem_C copy]];
                        }
                        
                    }
                    
                }else{
                    [formula_A addObject:[tem_S copy]];
                    tem_S =@"";
                    [formula_A addObject:[tem_C copy]];
                }
            }
        }
    }
    [formula_A removeObject:@""];
    NSLog(@"-------formula_A--------------%@",formula_A);
    return formula_A;
}




@end
