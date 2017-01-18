//
//  AudioWrapper.m
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import "AudioWrapper.h"
#import <Foundation/Foundation.h>
#import "lame.h"

@implementation AudioWrapper

+ (NSString*)audioPCMtoMP3 :(NSString *)audioFileSavePath :(NSString *)mp3FilePath
{
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([audioFileSavePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        NSLog(@"%@",audioFileSavePath);
        NSData * a = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:audioFileSavePath] options:NSDataReadingMappedIfSafe error:nil];
        NSLog(@"%@a",a);
        if (pcm == NULL) {
            return @"";
        };
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
        NSLog(@"MP3 converted: %@",mp3FilePath);
    }
    
}
@end
