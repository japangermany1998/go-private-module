package main

import (
	"fmt"
	"github.com/techmaster-vietnam/private_gomod"
	"github.com/kataras/iris/v12"
)

func main() {
	var post = getmodel.GetPost()
	fmt.Println(post)
	app := iris.New()
	app.Get("/",func(ctx iris.Context){
		ctx.JSON("success")
	})

	app.Run(iris.Addr(":8080"),iris.WithoutServerError(iris.ErrServerClosed))
}
