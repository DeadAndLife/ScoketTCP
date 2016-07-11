//
//  main.m
//  TCPClint
//
//  Created by qingyun on 16/7/9.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>//socket api
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //1.创建套接字对象
        int error;
        int fd = socket(AF_INET, SOCK_STREAM, 0);//创建套接字,(文件描述符,)
        BOOL success = (fd != -1);//2.绑定地址
        
        struct sockaddr_in addr;//套接字地址结构体
        if (success){
            memset(&addr, 0, sizeof(addr));//初始化内存
            addr.sin_len = sizeof(addr);//地址的长途
            addr.sin_family = AF_INET;//互联网协议,ipv4
            addr.sin_addr.s_addr = INADDR_ANY;//ip地址,因为是本机地址,指定为任意地址
            //绑定地址
            error = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));//绑定套接字的地址(ip和端口)
            success = (error == 0);
        }
        
        //准备和服务器建立连接
//        2.创建服务器套接字地址
        struct sockaddr_in peeraddr;//服务器套接字地址
        memset(&peeraddr, 0, sizeof(peeraddr));//初始化内存
        peeraddr.sin_len = sizeof(peeraddr);
        peeraddr.sin_family = AF_INET;//ipV4
        peeraddr.sin_port = htons(1024);//服务器的端口
        peeraddr.sin_addr.s_addr = inet_addr("192.168.6.125");//服务器的ip地址
        
        socklen_t addrlen;//服务器套接字地址的长度
        addrlen = sizeof(peeraddr);
        NSLog(@"begin connect");
        error = connect(fd, (struct sockaddr *)&peeraddr, addrlen);//和服务器建立连接
        success = (error == 0);//没有错误;
        if (success) {
            error = getsockname(fd, (struct sockaddr *)&addr, &addrlen);//本地socket绑定本地的IP地址
            success = (error == 0);
            if (success) {
                //建立连接成功
                NSLog(@"建立连接成功,本机地址:%s 本机端口:%d", inet_ntoa(addr.sin_addr),  ntohs(addr.sin_port));//读取本地socket的ip和端口
                char buf[1024];
                do {
                    printf("input message:");
                    scanf("%s", buf);
                    send(fd, buf, 1024, 0);
                } while (strcmp(buf, "exit")!= 0);
                
            }else{
                NSLog(@"连接失败");
            }
        
        }
        
        
        
        
        
        
    }
    return 0;
}
