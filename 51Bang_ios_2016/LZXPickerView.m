
#import "LZXPickerView.h"

@interface LZXPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView   *pickerView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) NSMutableArray *provincesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, assign) NSInteger row1;
@property (nonatomic, assign) NSInteger row2;
@property (nonatomic, assign) NSInteger row3;

@end

@implementation LZXPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addPickerView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.areaArray.count != 0) {
        NSLog(@"%ld,%ld,%ld",(long)self.row1,(long)self.row2,(long)self.row3);
        self.selectString = [NSString stringWithFormat:@"%@%@%@",self.provincesArray[0],self.cityArray[0],self.areaArray[0]];
    } else {
        self.selectString = [NSString stringWithFormat:@"%@%@",self.provincesArray[0],self.cityArray[0]];
    }
}
- (void)addPickerView
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
       return self.provincesArray.count;
    }else if (component == 1) {
        return self.cityArray.count;
    }else {
        return self.areaArray.count;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.selectedArray = self.dataArray[row][@"cities"];
        [self.cityArray removeAllObjects];
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArray addObject:obj[@"city"]];
        }];
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray firstObject][@"areas"]];
        NSLog(@"%@",self.areaArray);
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        self.row1 = row;
        NSLog(@"%ld",(long)self.row1);
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1) {
        if (self.selectedArray.count == 0) {
            self.selectedArray = [self.dataArray firstObject][@"cities"];
        }
        self.row2 = row;
        NSLog(@"%ld",(long)self.row2);
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray objectAtIndex:row][@"areas"]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        NSInteger index = [_pickerView selectedRowInComponent:0];
        NSInteger index1 = [_pickerView selectedRowInComponent:1];
        NSInteger index2 = [_pickerView selectedRowInComponent:2];
        NSLog(@"%lu",(unsigned long)self.areaArray.count);
        self.row3 = row;
        NSLog(@"%ld",(long)self.row3);
        if (self.areaArray.count != 0) {
            self.selectString = [NSString stringWithFormat:@"%@%@%@",self.provincesArray[index],self.cityArray[index1],self.areaArray[index2]];
        } else {
            self.selectString = [NSString stringWithFormat:@"%@%@",self.provincesArray[index],self.cityArray[index1]];
        }
    }
    NSInteger index = [_pickerView selectedRowInComponent:0];
    NSInteger index1 = [_pickerView selectedRowInComponent:1];
    NSInteger index2 = [_pickerView selectedRowInComponent:2];
    NSLog(@"%lu",(unsigned long)self.areaArray.count);
    self.row3 = row;
    NSLog(@"%ld",(long)self.row3);
    if (self.areaArray.count != 0) {
        self.selectString = [NSString stringWithFormat:@"%@%@%@",self.provincesArray[index],self.cityArray[index1],self.areaArray[index2]];
    } else {
        self.selectString = [NSString stringWithFormat:@"%@%@",self.provincesArray[index],self.cityArray[index1]];
    }
   

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provincesArray[row];
    }else if (component == 1) {
        return self.cityArray[row];
    }else {
        if (self.areaArray.count != 0) {
            return self.areaArray[row];
        }else {
            return nil;
        }
    }
}
#pragma mark  - 数据源
- (NSArray *)dataArray
{
    if (nil == _dataArray) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        _dataArray = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _dataArray;
}
#pragma mark - 初始化数据  只取第一组
- (NSMutableArray *)provincesArray
{
    if (nil == _provincesArray) {
        _provincesArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_provincesArray addObject:obj[@"state"]];
        }];
    }
    return _provincesArray;
}
- (NSMutableArray *)cityArray
{
    if (nil == _cityArray) {
        _cityArray = [NSMutableArray array];
        NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.dataArray firstObject][@"cities"]];
        [citys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_cityArray addObject:obj[@"city"]];
        }];
    }
    return _cityArray;
}
- (NSMutableArray *)areaArray
{
    if (nil == _areaArray) {
        NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.dataArray firstObject][@"cities"]];
        self.areaArray = [NSMutableArray arrayWithArray:[citys firstObject][@"areas"]];
    }
    return _areaArray;
}
- (NSMutableArray *)selectedArray
{
    if (nil == _selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
@end
