package main

import (
	"bytes"
	"log"
	"os/exec"
	"time"
	"io/ioutil"

	"github.com/gin-gonic/gin"
)

// func init() {
// 	file := "./" + "autoWeb" + ".log"
// 	logFile, err := os.OpenFile(file, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0644)
// 	if err != nil {
// 		panic(err)
// 	}
// 	log.SetOutput(logFile) // 将文件设置为log输出的文件
// 	log.SetPrefix("[qSkipTool]")
// 	log.SetFlags(log.LstdFlags | log.Lshortfile | log.LUTC)
// 	return
// }
func main() {
	web()
}

func web() {
	r := gin.Default()
	r.POST("/project", func(c *gin.Context) {
		t := time.Now().String()
		log.Println("==start==", t)
		project := c.Query("project")
		msg, err := execShell(project)
		c.JSON(200, gin.H{
			"message": msg,
			"err":     err,
		})
		dataBuff, _ := ioutil.ReadAll(c.Request.Body)
		log.Println(string(dataBuff))
		log.Println("err:\n", err)
		log.Println("msg:\n", msg)
		log.Println("==end==")
	})
	log.Println("listen and serve on 0.0.0.0:8888")
	r.Run(":8888")

}
func execShell(project string) (string, string) {
	gitURL := "git@git.i.garys.top:sre/" + project
	// gitURL := "https://xieshigang:123456@git.i.garys.top:sre/" + project
	branch := "master"
	temp1 := "project=" + project + " && space_path=/task/project/ && path=${space_path}${project}/children/templates && cd $path"
	temp2 := " && git pull " + gitURL + " " + branch + " && kubectl apply -f ."
	shell := temp1 + temp2
	// var buf strings.Builder
	// buf.WriteString(project)
	// buf.WriteString(cmd1)
	// buf.WriteString(cmd2)
	// shell := buf.String()
	log.Println("shell: ", shell)
	cmd := exec.Command("/bin/bash", "-c", shell)
	var out bytes.Buffer
	var err bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &err
	cmd.Run()
	return out.String(), err.String()
}
