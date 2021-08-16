# Cách sử dụng private module

## 1. Tự tạo một go module cho riêng bạn như khi làm go module public

Việc đầu tiên tạo một github repo private.
Ví dụ github repo có cấu trúc như sau
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

import "<git repo tại đây>/model"

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
Khi tạo xong github repo, giờ ta biến nó thành một go module. Để làm vậy ta không sử dụng branch để push mà thay vào đó dùng tag để cập nhật phiên bản.




