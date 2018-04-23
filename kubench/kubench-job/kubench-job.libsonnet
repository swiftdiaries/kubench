local k = import "k.libsonnet";

{
  parts:: {

    workflow(name, namespace, configImage, configArgs):: {
      "apiVersion": "argoproj.io/v1alpha1",
      "kind": "Workflow",
      "metadata": {
        "name": name,
        "namespace": namespace,
      },
      "spec": {
        "entrypoint": "kubench-workflow",
        "templates": [
          {
            "name": "kubench-workflow",
            "steps": [
              [
                {
                  "name": "config",
                  "template": "run-configurator",
                },
              ],
              [
                {
                  "name": "run",
                  "template": "run-job",
                  "arguments": {
                    "parameters": [
                      {
                        "name": "manifest",
                        "value": "{{steps.config.outputs.parameters.manifest}}",
                      },
                    ],
                  },
                },
              ],
            ],
          },
          {
            "name": "run-configurator",
            "container": {
              "image": configImage,
              "imagePullPolicy": "IfNotPresent",
              "args": configArgs,
            },
            "outputs": {
              "parameters": [
                {
                  "name": "manifest",
                  "valueFrom": {
                    "path": "/workspace/output.json"
                  },
                },
              ],
            },
          },
          {
            "name": "run-job", 
            "resource": {
              "action": "create",
              "successCondition": "status.phase == Done",
              "failureCondition": "status.phase == Failed",
              "manifest": "{{inputs.parameters.manifest}}",
            },
            "inputs": {
              "parameters": [
                {
                  "name": "manifest",
                },
              ],
            },
          }
        ],
      },
    },
  },
}
