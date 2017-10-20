//
//  CSPublicBetInputToolBarView.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPublicBetInputToolBarModel;
#import "CSBetInputView.h"
#import "CSMessageModel.h"

@protocol CSPublicBetInputToolBarViewDelegate <CSBetInputViewDelegate>

- (void)cs_betMessageModel:(CSMessageModel *)messageModel;

- (void)cs_betCancleMessageModel:(CSMessageModel *)messageModel;


@end
@interface CSPublicBetInputToolBarView : UIView
@property (nonatomic,weak) id<CSPublicBetInputToolBarViewDelegate> delegate;
- (void)cs_resignFirstResponder;
@property (nonatomic, strong)UIView * maskView;

/**
 更新用户身上分

 @param score <#score description#>
 */
- (void)updateUserScore:(NSString*)score;
@end

@interface CSPublicBetInputToolBarModel : NSObject

- (void)cleanBetMessage;



@property (nonatomic,copy) NSString *betType;
@property (nonatomic,copy) NSString *betName;
@property (nonatomic,copy) NSMutableString *betNumber;
@property (nonatomic,copy,readonly) NSString *betMessage;
@end
