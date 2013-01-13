//
//  GigyaExampleViewController.h
//  GigyaExample
//
//  Created by Brian Fagan on 8/28/12.
//  Copyright (c) 2012 Brian Fagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSAPI.h"

@interface GigyaExampleViewController : UIViewController<GSLoginUIDelegate, GSResponseDelegate>{
    GSAPI *gsAPI;
    IBOutlet UITextView *textView;
}
@property (nonatomic, retain) IBOutlet GSAPI *gsAPI;
@end
