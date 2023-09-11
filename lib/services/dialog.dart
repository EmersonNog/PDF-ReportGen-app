String getBotResponse(String question) {
  question = question.toLowerCase();

  if (question.contains("ajuda") ||
      question.contains("ajude") ||
      question.contains("help") ||
      question.contains("ajudar")) {
    return "Quer ajuda sobre quais das opções?\n\nLAUDO\nRELATÓRIO FOTOGRÁFRICO\nBANCO DE DADOS";
  } else if (question.contains("bom dia") ||
      question.contains("boa tarde") ||
      question.contains("boa noite") ||
      question.contains("oi") ||
      question.contains("oii") || 
      question.contains("e ai") ||
      question.contains("eai") ||   
      question.contains("eae") ||
      question.contains("ola") || 
      question.contains("olá") ||
      question.contains("hello")) {
    return "Olá, vai ser um prazer te ajudar, quer falar sobre quais das opções?\n\nLAUDO\nRELATÓRIO FOTOGRÁFRICO\nBANCO DE DADOS";
  }else if (question.contains("contato") ||
      question.contains("desenvolvedor")) {
    return 'Entre em contato com o desenvolvedor por um desses canais:\n\nEmail: catce.nogueira@gmail.com\nWhatsApp: (89) 9 9933-9734';
  } else if (question.contains("sobre")) {
    return 'Nosso aplicativo simplifica a criação de relatórios técnicos, automatizando a formatação e a organização. Os usuários economizam tempo ao usar o modelo pré-configurados para os relatórios e podem inserir facilmente textos e imagens. Isso reduz a formatação manual e melhora a eficiência geral do processo.\nNosso aplicativo possui um banco de dados na nuvem integrado. Isso permite a coleta contínua de dados e, após a coleta, uma análise mais minuciosa pode ser realizada para obter insights valiosos. Combinando organização, formatação e análise aprofundada, nosso aplicativo eleva a produtividade e a qualidade dos relatórios.';
  } else if (question.contains("relatório") ||
      question.contains("relatorio") ||
      question.contains("fotográfico") ||
      question.contains("fotografico")) {
    return "A fim de otimizar a estrutura e a clareza do relatório fotográfico, este é segmentado em quatro categorias distintas de imóveis. Caso você esteja enfrentando alguma dificuldade no processo, gentilmente siga as orientações abaixo para garantir um procedimento tranquilo e eficaz:\n\na) Certifique-se de que a pasta que está sendo criada possui um nome válido e apropriado, a fim de evitar quaisquer conflitos ou inconsistências no sistema.\n\nb) Verifique minuciosamente se todos os campos necessários estão preenchidos de maneira completa e precisa. Garantir o preenchimento adequado é fundamental para a geração do relatório de forma coerente, evitando quaisquer erros ou deficiências nas avaliações realizadas.\n\nc) No caso de experimentar dificuldades ao gerar o arquivo PDF contendo as imagens, solicitamos sua paciência. Pode ser necessário um breve período de espera para que o aplicativo processe de forma adequada todas as imagens e finalize a criação do arquivo.\n\n> Digite CONTATO caso seu problema/dúvida não tenha sido resolvido";
  } else if (question.contains("laudo")) {
    return "Esta com dúvidas em:\n\n1. Como sei se os dados foram para o banco de dados?\n\n2. Não estou conseguindo gerar o PDF";
  } else if (question.contains("1")) {
    return "Assim que o você clicar no botão 'Gerar PDF' e abrir um preview do PDF, os dados já foram armazenados com sucesso, pois passará por uma verificação de dados que só permite gerar um pré-PDF se os dados forem para a nuvem, caso contrário, os dados não estão armazenados.\n\n> Caso ainda esteja com dúvidas/problemas, digite CONTATO";
  } else if (question.contains("2")) {
    return "Na eventualidade de enfrentar problemas ao submeter o laudo no final do formulário, verifique se a localização do dispositivo móvel está ativada. Além disso, assegure-se de que o campo de código do laudo esteja preenchido, uma vez que esse código é essencial para gerar o PDF e armazenar os dados de forma segura na nuvem.\n\n> Caso ainda esteja com dúvidas/problemas, digite CONTATO";
  } else if (question.contains("banco") || question.contains("dados")) {
    return "Para estabelecer acesso ao banco de dados, é imperativo que haja conectividade à internet, a fim de viabilizar a autenticação do usuário.\n\n> Fale com o desenvolvedor caso sua dúvida persista, digite CONTATO.";
  } else {
    return "Faça perguntas relevantes ao contexto do aplicativo.";
  }
}
