#ifndef OSMSCOUT_FEATURE_READER_H
#define OSMSCOUT_FEATURE_READER_H

/*
  This source is part of the libosmscout library
  Copyright (C) 2018  Tim Teulings

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
*/

#include <limits>
#include <vector>

#include <osmscout/TypeFeature.h>
#include <osmscout/TypeFeatures.h>
#include <osmscout/TypeConfig.h>

namespace osmscout {

  /**
   * Helper template class for easy access to flag-like Features.
   *
   * Each type may have stored the feature in request at a different index. The FeatureReader
   * caches the index for each type once in the constructor and later on allows access to the feature
   * in O(1) - without iterating of all feature(values) of an object.
   */
  template<class F>
  class FeatureReader
  {
  private:
    std::vector<size_t> lookupTable;

  public:
    explicit FeatureReader(const TypeConfig& typeConfig);

    /**
     * Returns the index of the Feature/FeatureValue within the given FeatureValueBuffer.
     *
     * @param buffer
     *    The FeatureValueBuffer instance
     * @param index
     *    The index
     * @return
     *    true, if there is a valid index 8because the type has such feature), else false
     */
    bool GetIndex(const FeatureValueBuffer& buffer,
                  size_t& index) const;

    /**
     * Returns true, if the feature is set for the given FeatureValueBuffer
     * @param buffer
     *    The FeatureValueBuffer instance
     * @return
     *    true if set, else false
     */
    bool IsSet(const FeatureValueBuffer& buffer) const;
  };

  template<class F>
  FeatureReader<F>::FeatureReader(const TypeConfig& typeConfig)
  {
    FeatureRef feature=typeConfig.GetFeature(F::NAME);

    lookupTable.resize(typeConfig.GetTypeCount(),
                       std::numeric_limits<size_t>::max());

    for (const auto &type : typeConfig.GetTypes()) {
      size_t index;

      if (type->GetFeature(F::NAME,
                           index)) {
        lookupTable[type->GetIndex()]=index;
      }
    }
  }

  template<class F>
  bool FeatureReader<F>::GetIndex(const FeatureValueBuffer& buffer,
                                  size_t& index) const
  {
    index=lookupTable[buffer.GetType()->GetIndex()];

    return index!=std::numeric_limits<size_t>::max();
  }

  template<class F>
  bool FeatureReader<F>::IsSet(const FeatureValueBuffer& buffer) const
  {
    size_t index=lookupTable[buffer.GetType()->GetIndex()];

    if (index!=std::numeric_limits<size_t>::max()) {
      return buffer.HasFeature(index);
    }
    else {
      return false;
    }
  }

  typedef FeatureReader<AccessRestrictedFeature> AccessRestrictedFeatureReader;
  typedef FeatureReader<BridgeFeature>           BridgeFeatureReader;
  typedef FeatureReader<TunnelFeature>           TunnelFeatureReader;
  typedef FeatureReader<EmbankmentFeature>       EmbankmentFeatureReader;
  typedef FeatureReader<RoundaboutFeature>       RoundaboutFeatureReader;

  /**
   * Variant of FeatureReader that is not type set and thus can easier get used
   * in cases where runtime dynamics are required and features are referenced
   * by name and not by type.
   */
  class OSMSCOUT_API DynamicFeatureReader CLASS_FINAL
  {
  private:
    std::string         featureName;
    std::vector<size_t> lookupTable;

  public:
    DynamicFeatureReader(const TypeConfig& typeConfig,
                         const Feature& feature);

    inline std::string GetFeatureName() const
    {
      return featureName;
    }

    bool IsSet(const FeatureValueBuffer& buffer) const;

    FeatureValue* GetValue(const FeatureValueBuffer& buffer) const;
  };

  /**
   * Helper template class for easy access to the value of a certain feature for objects of any type.
   *
   * Each type may have stored the feature in request at a different index. The FeatureValueReader
   * caches the index for each type once in the constructor and later on allows access to the feature value
   * in O(1) - without iterating of all feature(values) of an object.
   */
  template<class F, class V>
  class FeatureValueReader
  {
  private:
    std::vector<size_t> lookupTable;

  public:
    explicit FeatureValueReader(const TypeConfig& typeConfig);

    /**
     * Returns the index of the Feature/FeatureValue within the given FeatureValueBuffer.
     *
     * @param buffer
     *    The FeatureValueBuffer instance
     * @param index
     *    The index
     * @return
     *    true, if there is a valid index 8because the type has such feature), else false
     */
    bool GetIndex(const FeatureValueBuffer& buffer,
                  size_t& index) const;

    /**
     * Returns the FeatureValue for the given FeatureValueBuffer
     * @param buffer
     *    The FeatureValueBuffer instance
     * @return
     *    A pointer to an instance if the Type and the instance do have the feature and its value is not NULL,
     *    else NULL
     */
    V* GetValue(const FeatureValueBuffer& buffer) const;
  };

  template<class F, class V>
  FeatureValueReader<F,V>::FeatureValueReader(const TypeConfig& typeConfig)
  {
    FeatureRef feature=typeConfig.GetFeature(F::NAME);

    assert(feature->HasValue());

    lookupTable.resize(typeConfig.GetTypeCount(),
                       std::numeric_limits<size_t>::max());

    for (const auto &type : typeConfig.GetTypes()) {
      size_t index;

      if (type->GetFeature(F::NAME,
                          index)) {
        lookupTable[type->GetIndex()]=index;
      }
    }
  }

  template<class F, class V>
  bool FeatureValueReader<F,V>::GetIndex(const FeatureValueBuffer& buffer,
                                         size_t& index) const
  {
    index=lookupTable[buffer.GetType()->GetIndex()];

    return index!=std::numeric_limits<size_t>::max();
  }

  template<class F, class V>
  V* FeatureValueReader<F,V>::GetValue(const FeatureValueBuffer& buffer) const
  {
    size_t index=lookupTable[buffer.GetType()->GetIndex()];

    if (index!=std::numeric_limits<size_t>::max() &&
        buffer.HasFeature(index)) {
      return dynamic_cast<V*>(buffer.GetValue(index));
    }
    else {
      return NULL;
    }
  }

  typedef FeatureValueReader<NameFeature,NameFeatureValue>                         NameFeatureValueReader;
  typedef FeatureValueReader<NameAltFeature,NameAltFeatureValue>                   NameAltFeatureValueReader;
  typedef FeatureValueReader<RefFeature,RefFeatureValue>                           RefFeatureValueReader;
  typedef FeatureValueReader<LocationFeature,LocationFeatureValue>                 LocationFeatureValueReader;
  typedef FeatureValueReader<AddressFeature,AddressFeatureValue>                   AddressFeatureValueReader;
  typedef FeatureValueReader<AccessFeature,AccessFeatureValue>                     AccessFeatureValueReader;
  typedef FeatureValueReader<AccessRestrictedFeature,AccessRestrictedFeatureValue> AccessRestrictedFeatureValueReader;
  typedef FeatureValueReader<LayerFeature,LayerFeatureValue>                       LayerFeatureValueReader;
  typedef FeatureValueReader<WidthFeature,WidthFeatureValue>                       WidthFeatureValueReader;
  typedef FeatureValueReader<MaxSpeedFeature,MaxSpeedFeatureValue>                 MaxSpeedFeatureValueReader;
  typedef FeatureValueReader<GradeFeature,GradeFeatureValue>                       GradeFeatureValueReader;
  typedef FeatureValueReader<AdminLevelFeature,AdminLevelFeatureValue>             AdminLevelFeatureValueReader;
  typedef FeatureValueReader<PostalCodeFeature,PostalCodeFeatureValue>             PostalCodeFeatureValueReader;
  typedef FeatureValueReader<IsInFeature,IsInFeatureValue>                         IsInFeatureValueReader;
  typedef FeatureValueReader<DestinationFeature,DestinationFeatureValue>           DestinationFeatureValueReader;
  typedef FeatureValueReader<ConstructionYearFeature,ConstructionYearFeatureValue> ConstructionYearFeatureValueReader;

  template <class F, class V>
  class FeatureLabelReader
  {
  private:
    std::vector<size_t> lookupTable;

  public:
    explicit FeatureLabelReader(const TypeConfig& typeConfig);

    /**
     * Returns the label of the given object
     * @param buffer
     *    The FeatureValueBuffer instance
     * @return
     *    The label, if the given feature has a value and a label  or a empty string
     */
    std::string GetLabel(const FeatureValueBuffer& buffer) const;
  };

  template<class F, class V>
  FeatureLabelReader<F,V>::FeatureLabelReader(const TypeConfig& typeConfig)
  {
    FeatureRef feature=typeConfig.GetFeature(F::NAME);

    assert(feature->HasLabel());

    lookupTable.resize(typeConfig.GetTypeCount(),
                       std::numeric_limits<size_t>::max());

    for (const auto &type : typeConfig.GetTypes()) {
      size_t index;

      if (type->GetFeature(F::NAME,
                           index)) {
        lookupTable[type->GetIndex()]=index;
      }
    }
  }

  template<class F, class V>
  std::string FeatureLabelReader<F,V>::GetLabel(const FeatureValueBuffer& buffer) const
  {
    size_t index=lookupTable[buffer.GetType()->GetIndex()];

    if (index!=std::numeric_limits<size_t>::max() &&
        buffer.HasFeature(index)) {
      V* value=dynamic_cast<V*>(buffer.GetValue(index));

      if (value!=nullptr) {
        return value->GetLabel(0);
      }
    }

    return "";
  }

  typedef FeatureLabelReader<NameFeature,NameFeatureValue>         NameFeatureLabelReader;

  /**
   * \defgroup type Object type related data structures and services
   */
}

#endif
