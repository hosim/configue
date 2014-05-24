# coding: utf-8
require File.expand_path("../spec_helper", __FILE__)

describe "Configue::Container" do
  context "when reading a single yaml file" do
    require File.expand_path("../samples/single_yaml_conf", __FILE__)

    context "1st level" do
      it_should_behave_like "an InnerHash instance",
        SingleYamlConf,
        {"foo" => ["baa"], "pee" => ["kaa0", "kaa1"]}
    end

    context "2nd level" do
      it_should_behave_like "an InnerHash instance",
        SingleYamlConf["foo"],
        {"baa" => ["baz0", "baz1"]}
      it_should_behave_like "an InnerHash instance",
        SingleYamlConf["pee"],
        {"kaa0" => ["boo"], "kaa1" => ["boo"]}
    end
  end

  context "when reading multiple yaml files" do
    require File.expand_path("../samples/multiple_yaml_conf", __FILE__)

    context "1st level" do
      it_should_behave_like "an InnerHash instance",
        MultipleYamlConf,
        {"foo" => ["baa", "bar", "pee"]}
    end

    context "2nd level" do
      it_should_behave_like "an InnerHash instance",
        MultipleYamlConf["foo"],
        {"baa" => ["baz"], "bar" => ["ding", "tick"], "pee" => ["kaa", "boo"]}
    end

    context "3rd level" do
      it_should_behave_like "an InnerHash instance",
        MultipleYamlConf["foo"]["baa"], {"baz" => nil}
      it_should_behave_like "an InnerHash instance",
        MultipleYamlConf["foo"]["pee"], {"kaa" => nil, "boo" => nil}
      it_should_behave_like "an InnerHash instance",
        MultipleYamlConf["foo"]["bar"],
        {"ding" => ["dong", "dang"], "tick" => ["tack", "toe"]}
    end
  end

  context "when reading a single yaml with source_file" do
    require File.expand_path("../samples/single_source_conf", __FILE__)

    context "1st level" do
      it_should_behave_like "an InnerHash instance",
        SingleSourceConf,
        {"config" => ["accounts"]}
    end

    context "2nd level" do
      it_should_behave_like "an InnerHash instance",
        SingleSourceConf["config"],
        {"accounts" => ["admin_users"]}
    end
  end

  context "when loading a yaml file with an array of records" do
    require File.expand_path("../samples/array_records_conf", __FILE__)

    describe "first record" do
      describe ".has_key?" do
        context 'when parameter is "name"' do
          it "returns true" do
            expect(ArrayRecordsConf.first).to have_key("name")
          end
        end

        context 'when parameter is "email"' do
          it "returns true" do
            expect(ArrayRecordsConf.first).to have_key("email")
          end
        end

        context "when parameter is :name" do
          it "returns true" do
            expect(ArrayRecordsConf.first).to have_key(:name)
          end
        end

        context "when parameter is :email" do
          it "returns true" do
            expect(ArrayRecordsConf.first).to have_key(:email)
          end
        end

        context 'when parameter is "foo"' do
          it "returns false" do
            expect(ArrayRecordsConf.first).not_to have_key("foo")
          end
        end

        context "when parameter is :foo" do
          it "returns false" do
            expect(ArrayRecordsConf.first).not_to have_key(:foo)
          end
        end
      end
    end
  end
end
