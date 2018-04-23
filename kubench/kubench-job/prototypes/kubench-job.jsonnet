// @apiVersion 0.1
// @name io.ksonnet.pkg.kubench-job
// @description A benchmark job on Kubeflow
// @shortDescription A benchmark job on Kubeflow
// @param name string Name to give to each of the components
// @optionalParam namespace string default Namespace
// @optionalParam config_image string null Configurator image
// @optionalParam config_args string null Configurator's arguments

local k = import "k.libsonnet";
local kubench = import "kubench/kubench-job/kubench-job.libsonnet";

local name = import "param://name";
local namespace = import "param://namespace";
local configImage = import "param://config_image";
local configArgs = import "param://config_args";

local args =
  if configArgs == "null" then
    []
  else
    std.split(configArgs, ",");

std.prune(k.core.v1.list.new([
  kubench.parts.workflow(name, namespace, configImage, args),
]))
