output "redis_endpoint" {
  description = "Primary endpoint address for Redis cluster"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_sg_id" {
  description = "Security group ID for Redis"
  value       = aws_security_group.redis.id
} 