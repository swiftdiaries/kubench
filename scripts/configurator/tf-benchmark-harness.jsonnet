local tfJob = import "tf-job.libsonnet";
// TODO: use the environment namespace if
// the namespace parameter is not explicitly set

local name = std.extVar("name");
local namespace = std.extVar("namespace");

local argsParam = std.extVar("args");
local args =
  if argsParam == "null" then
    []
  else
    std.split(argsParam, ",");

local image = std.extVar("image");
local imageGpu = std.extVar("imageGpu");
local numMasters = std.parseInt(std.extVar("numMasters"));
local numPs = std.parseInt(std.extVar("numPs"));
local numWorkers = std.parseInt(std.extVar("numWorkers"));
local numGpus = std.parseInt(std.extVar("numGpus"));

local terminationPolicy = if numMasters == 1 then
  tfJob.parts.tfJobTerminationPolicy("MASTER", 0)
else
  tfJob.parts.tfJobTerminationPolicy("WORKER", 0);

local workerSpec = if numGpus > 0 then
  tfJob.parts.tfJobReplica("WORKER", numWorkers, args, imageGpu, numGpus)
else
  tfJob.parts.tfJobReplica("WORKER", numWorkers, args, image);

std.prune(tfJob.parts.tfJob(
  name,
  namespace,
  [
    tfJob.parts.tfJobReplica("MASTER", numMasters, args, image),
    workerSpec,
    tfJob.parts.tfJobReplica("PS", numPs, args, image),
  ],
  terminationPolicy
))
