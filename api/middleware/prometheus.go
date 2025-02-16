package middleware

import (
	"api/utils"
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

func (mw *Mw) PrometheusMetrics() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		c.Next()
		duration := time.Since(start).Seconds()

		statusCode := c.Writer.Status()
		route := c.FullPath()
		method := c.Request.Method

		utils.RequestCount.WithLabelValues(method, route, http.StatusText(statusCode)).Inc()
		utils.RequestDuration.WithLabelValues(method, route).Observe(duration)

		if statusCode >= 400 {
			utils.FailedRequests.WithLabelValues(method, route, http.StatusText(statusCode)).Inc()
		}
	}
}
