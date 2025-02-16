package utils

import (
	"github.com/prometheus/client_golang/prometheus"
	"runtime"
)

var (
	RequestCount = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests.",
		},
		[]string{"method", "route", "status_code"},
	)

	RequestDuration = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "http_request_duration_seconds",
			Help:    "Histogram of HTTP request durations.",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"method", "route"},
	)

	FailedRequests = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_failed_total",
			Help: "Total number of failed HTTP requests.",
		},
		[]string{"method", "route", "status_code"},
	)

	memoryUsage = prometheus.NewGaugeFunc(
		prometheus.GaugeOpts{
			Name: "memory_usage_bytes",
			Help: "Current memory usage in bytes",
		},
		func() float64 {
			var memStats runtime.MemStats
			runtime.ReadMemStats(&memStats)
			return float64(memStats.Alloc)
		},
	)

	cpuUsage = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "cpu_usage_percentage",
		Help: "CPU usage percentage",
	})
)

func RegisterMetrics() {
	prometheus.MustRegister(RequestCount)
	prometheus.MustRegister(RequestDuration)
	prometheus.MustRegister(FailedRequests)
	prometheus.MustRegister(memoryUsage)
	prometheus.MustRegister(cpuUsage)
}
