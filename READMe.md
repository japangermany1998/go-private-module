# Các bước khởi tạo và đóng gói một project chạy với private module  
## 1. Tự tạo một go module như khi làm go module public

Việc đầu tiên tạo một go module và đẩy lên github repo private.

Ví dụ khi đẩy lên github repo có cấu trúc như sau

```
├──model/
|  ├──blog.go
├──main.go
├──go.mod
```

Trong model/blog.go:

```go
package model

type Post struct {
    Title string
    Content string
}
```

Trong main.go:

```go
package private_gomod

import "<module tại đây>/model"

func GetPost() model.Post {
    return model.Post{
        Title: "Tạo thử một private go module",
        Content:"Tạo thử thành công",
    }
}
```

Trong go.mod:

```go
module <git repo ở đây>

go 1.16
```

Khi tạo xong giờ ta cần release phiên bản cho nó. Để làm vậy tại github repository ta chọn Create a New Realease. Sẽ ra màn hình sau đây:

![](https://media.techmaster.vn/api/static/bm0tmgk51co4vclgfvu0/c4d386k51co7598b7jfg)

Ở đây mình nhập tag version v0.0.0 và title là "release lần đầu". Sau đấy publish release.

Vậy là bạn đã có một go module cho riêng mình.

## 2. Mang go module vào dự án

Bước đầu tiên ta cd vào thư mục dự án và sử dụng `go get <tên go module của bạn>`. Nhưng hiển thị lỗi **410 Gone**. Đó là bởi vì module của chúng ta đang là private. Để xử lý ta làm các bước sau:
### 2.1 Set GOPRIVATE
Tùy theo bạn muốn cài đặt private ở cấp độ nào. Giả sử toàn bộ dự án trên máy của bạn chỉ cần duy nhất một private go module thì bạn có thể đặt private là `github.com/<github username hoặc tổ chức của bạn>/<tên project module của bạn>`. Tức chỉ có duy nhất module này được mang vào dự án.
Nếu bạn sử dụng nhiều private go module thì có thể Set Private ở cấp độ tài khoản cá nhân hoặc tổ chức của bạn: `github.com/<github username hoặc tổ chức của bạn>`. Tức bất cứ private module trong tài khoản github hoặc tổ chức của bạn đều có thể sử dụng mang vào dự án
Ví dụ một tài khoản cá nhân là japangermany và bạn muốn sử dụng toàn bộ private module trong tài khoản này. Ta có thể Set GOPRIVATE bằng câu lệnh đơn giản:
```
go env -w GOPRIVATE=github.com/japangermany
```
Tương tự nếu muốn sử dụng toàn bộ private module trong tổ chức, ví dụ ở đây là techmaster.
```
go env -w GOPRIVATE=github.com/techmaster
```
Chỉ cho duy nhất một private module:
```
go env -w GOPRIVATE=github.com/japangermany/private_module
```

### 2.2 Truyền credentials cho GoModule.
Cũng như đăng nhập oauth2 cần có client_id, để sử dụng private GoModule bạn cần có token xác thực. Ở chế độ develop thì đã có câu lệnh git để làm việc đó.
Đầu tiên ta có thể tạo ra personal access token github [ở đây](https://github.com/settings/tokens)
Sau khi tạo xong đã có token, giờ bạn có thể dựng câu lệnh git sau:
```
git config --global url."https://${username}:${access_token}@github.com".insteadOf /
"https://github.com"
```
Truyền username và access token tương ứng. Như vậy bạn đã có thể thực hiện go get private module và mang được vào trong dự án.

## 3. Đóng gói docker
Ở trên ta mới mang private module vào được ở chế độ development, giờ nếu muốn đóng gói docker thế nào. Dưới đây là cách viết dockerfile đóng gói của mình:
```dockerfile
# Start from the latest golang base image
FROM golang:latest AS build

WORKDIR /app

# SET tên biến, sử dụng khi gõ câu lệnh docker build image
ARG GITHUB_USER=$GITHUB_USER
ARG GITHUB_TOKEN=$GITHUB_TOKEN

COPY go.mod .
COPY go.sum .

# Đăng nhập thông tin github để cấp quyền khi go mod download private module. Đây là bước quan trọng
RUN echo "machine github.com login $GITHUB_USER password $GITHUB_TOKEN" > ~/.netrc

RUN go mod download

COPY . .

# Câu lệnh để build và chạy được trên alpine
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o HelloGo .

# Nếu không muốn chạy trên alpine có thể bỏ qua các bước này và đi thẳng đến EXPOSE cổng
FROM alpine:latest

WORKDIR /app

COPY . .
COPY --from=build /app/HelloGo . 

EXPOSE 8080

ENTRYPOINT ["./HelloGo"]
```
Sau đó chạy:
```
docker build --build-arg GITHUB_USER=<tên github username> --build-arg GITHUB_TOKEN=<token của bạn> -t <tên image> .
```
Vậy là bạn đã đóng gói được image thành công. Ta chỉ việc sử dụng câu lệnh `docker run` để chạy container và có một ứng dụng trên máy.
