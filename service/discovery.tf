#### Service Discovery Service
resource aws_service_discovery_service "this" {

    count = var.enable_service_discovery ? 1 : 0
   
    name = var.service_name

    dns_config {
        namespace_id = var.namespace_id

        routing_policy = var.service_routing_policy
        dns_records {
            ttl  = 10
            type = "A"
        }
    }
    health_check_custom_config {
        failure_threshold = 5
    }
}