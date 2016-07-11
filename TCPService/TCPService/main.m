//
//  main.m
//  TCPService
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
        BOOL success = (fd != -1);
        
        //2.绑定地址
        if (success){
            struct sockaddr_in addr;//套接字地址结构体
            memset(&addr, 0, sizeof(addr));//初始化内存
            addr.sin_len = sizeof(addr);//地址的长途
            addr.sin_family = AF_INET;//互联网协议,ipv4
            addr.sin_port = htons(1024);//指定端口
            addr.sin_addr.s_addr = INADDR_ANY;//ip地址,因为是本机地址,指定为任意地址
            
            //绑定地址
            error = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));//绑定套接字的地址(ip和端口)
            success = (error == 0);
        }
        
        //3.监听端口
        if (success) {
            NSLog(@"绑定成功");
            error = listen(fd, 5);//开始监听
            
            success = (error == 0);
        }
        if (success){
            NSLog(@"listen 成功");
            struct sockaddr_in peeraddr;//接受的套接字地址
            int peerfd;//接受的套接字(文件描述符)
            socklen_t addrlen;
            addrlen = sizeof(peeraddr);//套接字地址长度
            //4.接受连接
            peerfd = accept(fd, (struct sockaddr *)&peeraddr, &addrlen);//收到接收,得到接受的套接字,并且得到接受的套接字的地址,接受的套接字地址的长度;
            success = (peerfd != -1);
            if (success) {
                //5.收发消息
                NSLog(@"accept remote addr:%s port :%d", inet_ntoa(peeraddr.sin_addr), ntohs(peeraddr.sin_port));//输出可见的ip地址和端口
                char buf[1024];//数组容器
                ssize_t count;//读的长度,结果的长度
                size_t size = sizeof(buf);//一次读的长度
                do {
                    count = recv(peerfd, buf, size, 0);//接受指定长度的内容
                    NSString *str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", str);
                } while (strcmp(buf, "exit") != 0);
                
                close(peerfd);//断开连接
                
            }
            
        }
    }
    return 0;
}
