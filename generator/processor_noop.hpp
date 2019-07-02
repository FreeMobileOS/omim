#pragma once

#include "generator/feature_builder.hpp"
#include "generator/processor_interface.hpp"

#include <memory>
#include <string>
#include <vector>

class FeatureParams;

namespace generator
{
class ProcessorNoop : public FeatureProcessorInterface
{
public:
  // FeatureProcessorInterface overrides:
  std::shared_ptr<FeatureProcessorInterface> Clone() const override
  {
    return std::make_shared<ProcessorNoop>();
  }

  void Process(feature::FeatureBuilder &) override {}
  void Flush() override {}
  bool Finish() override { return true; }


  void Merge(FeatureProcessorInterface const &) override {}
  void MergeInto(ProcessorNoop &) const override {}
};
}  // namespace generator
