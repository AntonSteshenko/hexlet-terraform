// main.tf - имя файла выбрано произвольно, важно только расширение
terraform {
  required_providers {
    // Здесь указываются все провайдеры, которые будут использоваться
    digitalocean = {
      source = "digitalocean/digitalocean"
      // Версия может обновиться
      version = "~> 2.0"
    }
    datadog = {
      source = "DataDog/datadog"
      version = "~> 3.29.0"
    }
  }
}

// Terraform должен знать ключ, для выполнения команд по API

// Определение переменной, которую нужно будет задать
variable "do_token" {}
variable "datadog_api_key" {}
variable "datadog_app_key" {}

// Установка значения переменной
provider "digitalocean" {
  token = var.do_token
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu/"
}

// Пример взят из документации
// web - произвольное имя ресурса
resource "digitalocean_droplet" "web1" {
  image  = "ubuntu-22-04-x64"
  // Имя внутри Digital Ocean
  // Задается для удобства просмотра в веб-интерфейсе
  name   = "web-1"
  // Регион, в котором располагается датацентр
  // Выбирается по принципу близости к клиентам
  region = "fra1"
  // Тип сервера, от этого зависит его мощность и стоимость
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "web2" {
  image  = "ubuntu-22-04-x64"
  name   = "web-2"
  region = "fra1"
  size   = "s-1vcpu-1gb"
}

resource "datadog_monitor" "cpumonitor" {
  name = "cpu monitor"
  type = "metric alert"
  message = "CPU usage alert"
  query = "avg(last_1m):avg:system.cpu.system{*} by {host} > 60"
}