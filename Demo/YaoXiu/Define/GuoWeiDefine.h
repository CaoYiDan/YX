
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/** 获取主Window */
#define m_KeyWindow [UIApplication sharedApplication].keyWindow
/** 颜色值RGB */
#define m_Color_RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
/** 颜色值RGBA */
#define m_Color_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
/** 灵活灰色 */
#define m_Color_gray(value) m_Color_RGB(value, value, value)
/** Toast */
#define m_ToastTop(topStr) m_Toast(topStr,CSToastPositionTop)
#define m_ToastBottom(bottomStr) m_Toast(bottomStr,CSToastPositionBottom)
#define m_ToastCenter(centerStr) m_Toast(centerStr,CSToastPositionCenter)
#define m_Toast(str,toastPosition)  CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
style.backgroundColor = [m_Color_gray(51) colorWithAlphaComponent:0.7];\
style.cornerRadius = 4;\
style.titleFont = m_FontPF_Regular_WithSize(15);\
style.messageFont = m_FontPF_Regular_WithSize(15);\
style.horizontalPadding = 18;\
style.verticalPadding = 28;\
[m_KeyWindow makeToast:str duration:2 position:toastPosition style:style];\

#define mf_isNull(x)             (!x || [x isKindOfClass:[NSNull class]])

#define isEmptyString(x)      (mf_isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"])

/** 存储对象 */
#define m_UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
/** 获得存储的对象 */
#define m_UserDefaultObjectForKey(__KEY__) [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]
/** delete objects删除对象 */
#define m_UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define temp_user_id [[NSUserDefaults standardUserDefaults] objectForKey:@"temp_user_id"]

/** 检测是否登录 */
#define m_CheckUserLogin \
if (!AccountMannger_isLogin) {\
[LoginViewController gw_showLoginVCWithCompletion:nil];\
return;\
}
