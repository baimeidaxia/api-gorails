package util

import (
	"fmt"
	"github.com/astaxie/beego/orm"
	"time"
)

type JsonTime time.Time

func (e JsonTime) MarshalJSON() ([]byte, error) {
	var stamp = fmt.Sprintf("\"%s\"", time.Time(e).Format("2006-01-02 15:04:05"))
	return []byte(stamp), nil
}

func (e JsonTime) String() string {
	return time.Time(e).Format("2006-01-02 15:04:05")
}

func (e *JsonTime) FieldType() int {
	return orm.TypeDateTimeField
}

func (e *JsonTime) Set(d time.Time) {
	*e = JsonTime(d)
}

func (e *JsonTime) SetRaw(value interface{}) error {
	if value == nil {
		return nil
	}
	switch d := value.(type) {
	case time.Time:
		e.Set(d)
	case string:
		v, err := timeParse(d, "2006-01-02 15:04:05")
		if err != nil {
			e.Set(v)
		}
		return err
	default:
		return fmt.Errorf("<JsonTime.SetRaw> unknown value `%s`", value)
	}
	return nil
}

func (e *JsonTime) RawValue() interface{} {
	return e.String()
}

// parse time to string with location
func timeParse(dateString, format string) (time.Time, error) {
	tp, err := time.ParseInLocation(format, dateString, time.Local)
	return tp, err
}