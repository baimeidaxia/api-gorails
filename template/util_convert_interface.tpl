package util

import (
	"strconv"
	"time"
)

func ConvertInt(s interface{}) int {
	v, _ := strconv.Atoi(s.(string))
	return v
}

func ConvertTime(s interface{}) time.Time {
	t, _ := time.Parse("2006-01-02 15:04:05", s.(string))
	return t
}

func ConvertJsonTime(s interface{}) JsonTime {
	t, _ := time.Parse("2006-01-02 15:04:05", s.(string))
	return JsonTime(t)
}
