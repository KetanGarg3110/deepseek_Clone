class AiGeneratedModel {
  String? id;
  String? provider;
  String? model;
  String? object;
  int? created;
  List<Choices>? choices;
  Usage? usage;

  AiGeneratedModel(
      {this.id,
        this.provider,
        this.model,
        this.object,
        this.created,
        this.choices,
        this.usage});

  AiGeneratedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provider = json['provider'];
    model = json['model'];
    object = json['object'];
    created = json['created'];
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(new Choices.fromJson(v));
      });
    }
    usage = json['usage'] != null ? new Usage.fromJson(json['usage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider'] = this.provider;
    data['model'] = this.model;
    data['object'] = this.object;
    data['created'] = this.created;
    if (this.choices != null) {
      data['choices'] = this.choices!.map((v) => v.toJson()).toList();
    }
    if (this.usage != null) {
      data['usage'] = this.usage!.toJson();
    }
    return data;
  }
}

class Choices {
  dynamic logprobs; // fixed was NUll
  String? finishReason;
  String? nativeFinishReason;
  int? index;
  Message? message;

  Choices(
      {this.logprobs,
        this.finishReason,
        this.nativeFinishReason,
        this.index,
        this.message});

  Choices.fromJson(Map<String, dynamic> json) {
    logprobs = json['logprobs'];
    finishReason = json['finish_reason'];
    nativeFinishReason = json['native_finish_reason'];
    index = json['index'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logprobs'] = this.logprobs;
    data['finish_reason'] = this.finishReason;
    data['native_finish_reason'] = this.nativeFinishReason;
    data['index'] = this.index;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  String? role;
  String? content;
  dynamic refusal;
  String? reasoning;

  Message({this.role, this.content, this.refusal, this.reasoning});

  Message.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
    refusal = json['refusal'];
    reasoning = json['reasoning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['content'] = this.content;
    data['refusal'] = this.refusal;
    data['reasoning'] = this.reasoning;
    return data;
  }
}

class Usage {
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  Usage({this.promptTokens, this.completionTokens, this.totalTokens});

  Usage.fromJson(Map<String, dynamic> json) {
    promptTokens = json['prompt_tokens'];
    completionTokens = json['completion_tokens'];
    totalTokens = json['total_tokens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prompt_tokens'] = this.promptTokens;
    data['completion_tokens'] = this.completionTokens;
    data['total_tokens'] = this.totalTokens;
    return data;
  }
}
